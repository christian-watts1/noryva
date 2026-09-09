mock_provider "aws" {}
variables {
  name             = "noryva-test"
  production       = false
  email_source_arn = "arn:aws:ses:eu-west-2:123456789012:identity/example.invalid"
}
run "passwordless_native" {
  command = plan
  assert {
    condition     = !aws_cognito_user_pool_client.native.generate_secret && aws_cognito_user_pool_client.native.explicit_auth_flows == toset(["ALLOW_USER_AUTH"])
    error_message = "Native client must not accept passwords or have a secret."
  }
  assert {
    condition     = aws_cognito_user_pool.this.sign_in_policy[0].allowed_first_auth_factors == toset(["EMAIL_OTP"]) && aws_cognito_user_pool.this.user_pool_tier == "ESSENTIALS"
    error_message = "Only email OTP is enabled."
  }
  assert {
    condition     = aws_cognito_user_pool_client.native.enable_token_revocation && aws_cognito_user_pool_client.native.access_token_validity == 5 && aws_cognito_user_pool_client.native.prevent_user_existence_errors == "ENABLED"
    error_message = "Short tokens and generic identity errors required."
  }
}
run "production_protection" {
  command = plan
  variables { production = true }
  assert {
    condition     = aws_cognito_user_pool.this.deletion_protection == "ACTIVE"
    error_message = "Production identity requires deletion protection."
  }
}
