variable "name" { type = string }
variable "production" { type = bool }
variable "email_source_arn" {
  type        = string
  description = "Separately approved existing SES identity; this module creates no SES resources."
  validation {
    condition     = can(regex("^arn:aws:ses:eu-west-2:[0-9]{12}:identity/", var.email_source_arn))
    error_message = "An approved London SES identity ARN is required for email OTP."
  }
}
resource "aws_cognito_user_pool" "this" {
  name                     = var.name
  user_pool_tier           = "ESSENTIALS"
  deletion_protection      = var.production ? "ACTIVE" : "INACTIVE"
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  username_configuration { case_sensitive = false }
  mfa_configuration = "OFF"
  sign_in_policy { allowed_first_auth_factors = ["EMAIL_OTP"] }
  account_recovery_setting {
    recovery_mechanism {
      name     = "admin_only"
      priority = 1
    }
  }
  email_configuration {
    email_sending_account = "DEVELOPER"
    source_arn            = var.email_source_arn
  }
}
resource "aws_cognito_user_pool_client" "native" {
  name                          = "${var.name}-native"
  user_pool_id                  = aws_cognito_user_pool.this.id
  generate_secret               = false
  explicit_auth_flows           = ["ALLOW_USER_AUTH"]
  prevent_user_existence_errors = "ENABLED"
  enable_token_revocation       = true
  refresh_token_rotation {
    feature                    = "ENABLED"
    retry_grace_period_seconds = 0
  }
  access_token_validity  = 5
  id_token_validity      = 5
  refresh_token_validity = 1
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
  read_attributes  = ["email", "email_verified"]
  write_attributes = ["email"]
}
output "issuer" { value = "https://cognito-idp.eu-west-2.amazonaws.com/${aws_cognito_user_pool.this.id}" }
output "client_id" { value = aws_cognito_user_pool_client.native.id }
