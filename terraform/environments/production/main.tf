terraform {
  required_version = ">= 1.10, < 2.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
}
provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = { Application = "Noryva", Environment = "production", ManagedBy = "Terraform" }
  }
}
variable "enable_database" {
  type        = bool
  default     = false
  description = "Explicit opt-in for paid isolated PostgreSQL integration infrastructure."
}
variable "artifact_path" {
  type    = string
  default = "../../../backend/dist/lambda.zip"
}
variable "enable_identity" {
  type        = bool
  default     = false
  description = "Code-only identity opt-in; no deployment authorised by Phase 2C."
}
variable "identity_email_source_arn" {
  type    = string
  default = null
}
module "foundation" {
  identity_email_source_arn = var.identity_email_source_arn
  enable_identity           = var.enable_identity
  source                    = "../../modules/foundation"
  environment               = "production"
  artifact_path             = var.artifact_path
  enable_database           = var.enable_database
}
output "api_endpoint" { value = module.foundation.api_endpoint }
output "database_host" { value = module.foundation.database_host }
output "master_secret_arn" {
  value     = module.foundation.master_secret_arn
  sensitive = true
}
