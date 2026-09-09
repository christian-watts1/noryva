mock_provider "aws" {
  mock_data "aws_caller_identity" {
    defaults = { account_id = "123456789012" }
  }
  mock_data "aws_region" {
    defaults = { region = "eu-west-2", name = "eu-west-2" }
  }
  mock_data "aws_partition" {
    defaults = { partition = "aws" }
  }
}
variables {
  name          = "noryva-test"
  environment   = "staging"
  artifact_path = "../../../backend/dist/lambda.zip"
}
run "minimal_api" {
  command = plan
  assert {
    condition     = aws_apigatewayv2_api.this.protocol_type == "HTTP" && length(aws_apigatewayv2_route.health) == 2
    error_message = "Only foundation HTTP routes are allowed."
  }
  assert {
    condition     = length(aws_lambda_function.api.vpc_config) == 0 && length(aws_iam_role_policy.eni) == 0 && length(aws_iam_role_policy.database) == 0
    error_message = "DB-free staging needs no VPC or database IAM."
  }
  assert {
    condition     = aws_lambda_function.api.reserved_concurrent_executions == 2 && aws_cloudwatch_log_group.lambda.retention_in_days == 14
    error_message = "Bound concurrency and log retention."
  }
}
run "database_api" {
  command = plan
  variables {
    database = { host = "private.example", resource_id = "db-123", subnet_ids = ["subnet-a", "subnet-b"], security_group_id = "sg-test" }
  }
  assert {
    condition     = length(aws_lambda_function.api.vpc_config) == 1 && aws_lambda_function.api.environment[0].variables.DB_MODE == "iam"
    error_message = "Database API must use private VPC access and IAM auth."
  }
  assert {
    condition     = jsondecode(aws_iam_role_policy.database[0].policy).Statement[0].Action == ["rds-db:connect"]
    error_message = "API must not acquire administrator or secret permissions."
  }
}
run "protected_identity" {
  command = plan
  variables {
    identity = { issuer = "https://cognito-idp.eu-west-2.amazonaws.com/eu-west-2_test", client_id = "native" }
  }
  assert {
    condition     = length(aws_apigatewayv2_route.identity) == 4 && alltrue([for r in aws_apigatewayv2_route.identity : r.authorization_type == "CUSTOM"])
    error_message = "Every identity route requires cryptographic authorization."
  }
  assert {
    condition     = aws_apigatewayv2_authorizer.identity[0].authorizer_result_ttl_in_seconds == 0 && length(aws_lambda_function.authorizer[0].vpc_config) == 0
    error_message = "Do not cache identity decisions or add NAT for JWKS."
  }
}

run "bounded_email_exchange" {
  command = plan
  variables { identity = { issuer = "https://cognito-idp.eu-west-2.amazonaws.com/eu-west-2_test", client_id = "native" } }
  assert {
    condition     = length(aws_apigatewayv2_route.email) == 1 && aws_apigatewayv2_route.email[0].route_key == "POST /v1/auth/email" && length(aws_lambda_function.email[0].vpc_config) == 0 && aws_lambda_function.email[0].reserved_concurrent_executions == 2
    error_message = "OTP exchange must stay bounded and avoid NAT/database permissions."
  }
}
