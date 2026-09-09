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
module "foundation" {
  source          = "../../modules/foundation"
  environment     = "production"
  artifact_path   = var.artifact_path
  enable_database = var.enable_database
}
output "api_endpoint" { value = module.foundation.api_endpoint }
output "database_host" { value = module.foundation.database_host }
output "master_secret_arn" {
  value     = module.foundation.master_secret_arn
  sensitive = true
}
