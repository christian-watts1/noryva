variable "name" { type = string }
variable "environment" { type = string }
variable "artifact_path" { type = string }
variable "database" {
  type    = object({ host = string, resource_id = string, subnet_ids = list(string), security_group_id = string })
  default = null
}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = 14
}
resource "aws_cloudwatch_log_group" "api" {
  name              = "/noryva/${var.environment}/http-api"
  retention_in_days = 14
}
resource "aws_iam_role" "api" {
  name               = "${var.name}-api"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Principal = { Service = "lambda.amazonaws.com" }, Action = "sts:AssumeRole" }] })
}
resource "aws_iam_role_policy" "logs" {
  role = aws_iam_role.api.id
  policy = jsonencode({ Version = "2012-10-17", Statement = [{
    Effect = "Allow", Action = ["logs:CreateLogStream", "logs:PutLogEvents"], Resource = "${aws_cloudwatch_log_group.lambda.arn}:*"
  }] })
}
resource "aws_iam_role_policy" "database" {
  count = var.database == null ? 0 : 1
  role  = aws_iam_role.api.id
  policy = jsonencode({ Version = "2012-10-17", Statement = [{
    Effect = "Allow", Action = ["rds-db:connect"], Resource = "arn:${data.aws_partition.current.partition}:rds-db:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:dbuser:${var.database.resource_id}/noryva_api"
  }] })
}
resource "aws_iam_role_policy" "eni" {
  count = var.database == null ? 0 : 1
  role  = aws_iam_role.api.id
  # These Lambda ENI operations require Resource "*"; see security document.
  policy = jsonencode({ Version = "2012-10-17", Statement = [
    { Effect = "Allow", Action = ["ec2:CreateNetworkInterface", "ec2:DescribeNetworkInterfaces", "ec2:DescribeSubnets", "ec2:DeleteNetworkInterface", "ec2:AssignPrivateIpAddresses", "ec2:UnassignPrivateIpAddresses"], Resource = "*" },
    { Effect = "Deny", Action = ["ec2:CreateNetworkInterface", "ec2:DeleteNetworkInterface", "ec2:AssignPrivateIpAddresses", "ec2:UnassignPrivateIpAddresses"], Resource = "*", Condition = { ArnEquals = { "lambda:SourceFunctionArn" = "arn:${data.aws_partition.current.partition}:lambda:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:function:${var.name}" } } }
  ] })
}
resource "aws_lambda_function" "api" {
  function_name                  = var.name
  role                           = aws_iam_role.api.arn
  runtime                        = "nodejs24.x"
  architectures                  = ["arm64"]
  handler                        = "index.handler"
  filename                       = var.artifact_path
  source_code_hash               = filebase64sha256(var.artifact_path)
  memory_size                    = 256
  timeout                        = 10
  reserved_concurrent_executions = 2
  environment {
    variables = merge({ APP_ENV = var.environment, DB_MODE = var.database == null ? "disabled" : "iam", MAX_BODY_BYTES = "16384" }, var.database == null ? {} : {
      DB_HOST = var.database.host, DB_PORT = "5432", DB_NAME = "noryva", DB_USER = "noryva_api", DB_CA_FILE = "/var/runtime/ca-cert.pem"
    })
  }
  dynamic "vpc_config" {
    for_each = var.database == null ? [] : [var.database]
    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = [vpc_config.value.security_group_id]
    }
  }
  depends_on = [aws_iam_role_policy.logs, aws_iam_role_policy.eni, aws_iam_role_policy.database]
}
resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  protocol_type = "HTTP"
}
resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.api.invoke_arn
  payload_format_version = "2.0"
  timeout_milliseconds   = 10000
}
resource "aws_apigatewayv2_route" "health" {
  for_each           = toset(["GET /health", "GET /ready"])
  api_id             = aws_apigatewayv2_api.this.id
  route_key          = each.value
  target             = "integrations/${aws_apigatewayv2_integration.lambda.id}"
  authorization_type = "NONE"
}
resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
  default_route_settings {
    throttling_burst_limit = 4
    throttling_rate_limit  = 2
  }
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api.arn
    # No raw path, IP, body, headers, query strings or integration error messages.
    format = jsonencode({ requestId = "$context.requestId", route = "$context.routeKey", status = "$context.status", latency = "$context.responseLatency" })
  }
}
resource "aws_lambda_permission" "gateway" {
  for_each       = toset(["health", "ready"])
  statement_id   = "Gateway-${each.value}"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.api.function_name
  principal      = "apigateway.amazonaws.com"
  source_account = data.aws_caller_identity.current.account_id
  source_arn     = "${aws_apigatewayv2_api.this.execution_arn}/*/GET/${each.value}"
}
output "api_endpoint" { value = aws_apigatewayv2_api.this.api_endpoint }
output "api_role_arn" { value = aws_iam_role.api.arn }
