variable "identity" {
  type    = object({ issuer = string, client_id = string })
  default = null
}
variable "authorizer_artifact_path" {
  type    = string
  default = "../../../backend/dist/authorizer.zip"
}
resource "aws_cloudwatch_log_group" "authorizer" {
  count             = var.identity == null ? 0 : 1
  name              = "/aws/lambda/${var.name}-authorizer"
  retention_in_days = 14
}
resource "aws_iam_role" "authorizer" {
  count              = var.identity == null ? 0 : 1
  name               = "${var.name}-authorizer"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Principal = { Service = "lambda.amazonaws.com" }, Action = "sts:AssumeRole" }] })
}
resource "aws_iam_role_policy" "authorizer_logs" {
  count  = var.identity == null ? 0 : 1
  role   = aws_iam_role.authorizer[0].id
  policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Action = ["logs:CreateLogStream", "logs:PutLogEvents"], Resource = "${aws_cloudwatch_log_group.authorizer[0].arn}:*" }] })
}
resource "aws_lambda_function" "authorizer" {
  count                          = var.identity == null ? 0 : 1
  function_name                  = "${var.name}-authorizer"
  role                           = aws_iam_role.authorizer[0].arn
  runtime                        = "nodejs24.x"
  architectures                  = ["arm64"]
  handler                        = "authorizer.handler"
  filename                       = var.authorizer_artifact_path
  source_code_hash               = filebase64sha256(var.authorizer_artifact_path)
  memory_size                    = 256
  timeout                        = 5
  reserved_concurrent_executions = 2
  environment { variables = { AUTH_ISSUER = var.identity.issuer, AUTH_CLIENT_ID = var.identity.client_id } }
  depends_on = [aws_iam_role_policy.authorizer_logs]
}
resource "aws_apigatewayv2_authorizer" "identity" {
  count                             = var.identity == null ? 0 : 1
  api_id                            = aws_apigatewayv2_api.this.id
  name                              = "verified-identity"
  authorizer_type                   = "REQUEST"
  authorizer_uri                    = aws_lambda_function.authorizer[0].invoke_arn
  authorizer_payload_format_version = "2.0"
  enable_simple_responses           = true
  authorizer_result_ttl_in_seconds  = 0
  identity_sources                  = ["$request.header.Authorization"]
}
resource "aws_lambda_permission" "authorizer" {
  count          = var.identity == null ? 0 : 1
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.authorizer[0].function_name
  principal      = "apigateway.amazonaws.com"
  source_account = data.aws_caller_identity.current.account_id
  source_arn     = "${aws_apigatewayv2_api.this.execution_arn}/authorizers/${aws_apigatewayv2_authorizer.identity[0].id}"
}
locals { identity_routes = var.identity == null ? toset([]) : toset(["POST /v1/account/session", "POST /v1/devices/register", "GET /v1/account", "POST /v1/devices/{deviceId}/revoke"]) }
resource "aws_apigatewayv2_route" "identity" {
  for_each           = local.identity_routes
  api_id             = aws_apigatewayv2_api.this.id
  route_key          = each.value
  target             = "integrations/${aws_apigatewayv2_integration.lambda.id}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.identity[0].id
}
resource "aws_lambda_permission" "identity" {
  for_each       = local.identity_routes
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.api.function_name
  principal      = "apigateway.amazonaws.com"
  source_account = data.aws_caller_identity.current.account_id
  source_arn     = "${aws_apigatewayv2_api.this.execution_arn}/*/${replace(replace(each.value, " ", ""), "{deviceId}", "*")}"
}

# Public, bounded email OTP exchange. No database access or AWS API permissions.
resource "aws_cloudwatch_log_group" "email" {
  count             = var.identity == null ? 0 : 1
  name              = "/aws/lambda/${var.name}-email"
  retention_in_days = 14
}
resource "aws_iam_role_policy" "email_logs" {
  count  = var.identity == null ? 0 : 1
  role   = aws_iam_role.authorizer[0].id
  policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Action = ["logs:CreateLogStream", "logs:PutLogEvents"], Resource = "${aws_cloudwatch_log_group.email[0].arn}:*" }] })
}
resource "aws_lambda_function" "email" {
  count                          = var.identity == null ? 0 : 1
  function_name                  = "${var.name}-email"
  role                           = aws_iam_role.authorizer[0].arn
  runtime                        = "nodejs24.x"
  architectures                  = ["arm64"]
  handler                        = "authorizer.emailHandler"
  filename                       = var.authorizer_artifact_path
  source_code_hash               = filebase64sha256(var.authorizer_artifact_path)
  memory_size                    = 256
  timeout                        = 6
  reserved_concurrent_executions = 2
  environment { variables = { AUTH_CLIENT_ID = var.identity.client_id } }
  depends_on = [aws_iam_role_policy.email_logs]
}
resource "aws_apigatewayv2_integration" "email" {
  count                  = var.identity == null ? 0 : 1
  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.email[0].invoke_arn
  payload_format_version = "2.0"
  timeout_milliseconds   = 7000
}
resource "aws_apigatewayv2_route" "email" {
  count              = var.identity == null ? 0 : 1
  api_id             = aws_apigatewayv2_api.this.id
  route_key          = "POST /v1/auth/email"
  target             = "integrations/${aws_apigatewayv2_integration.email[0].id}"
  authorization_type = "NONE"
}
resource "aws_lambda_permission" "email" {
  count          = var.identity == null ? 0 : 1
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.email[0].function_name
  principal      = "apigateway.amazonaws.com"
  source_account = data.aws_caller_identity.current.account_id
  source_arn     = "${aws_apigatewayv2_api.this.execution_arn}/*/POST/v1/auth/email"
}
