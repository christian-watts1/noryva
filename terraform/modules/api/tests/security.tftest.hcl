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
