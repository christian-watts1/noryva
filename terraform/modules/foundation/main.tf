variable "environment" {
  type = string
  validation {
    condition     = contains(["staging", "production"], var.environment)
    error_message = "Use staging or production."
  }
}
variable "artifact_path" { type = string }
variable "enable_database" { type = bool }
locals { name = "noryva-${var.environment}" }
module "network" {
  count              = var.enable_database ? 1 : 0
  source             = "../network"
  name               = local.name
  cidr               = var.environment == "production" ? "10.42.0.0/16" : "10.41.0.0/16"
  availability_zones = ["eu-west-2a", "eu-west-2b"]
}
module "database" {
  count             = var.enable_database ? 1 : 0
  source            = "../database"
  name              = local.name
  subnet_ids        = module.network[0].subnet_ids
  security_group_id = module.network[0].database_security_group_id
  production        = var.environment == "production"
  # IAM auth has material memory overhead: use 2 GiB small, not 1 GiB micro.
  instance_class = "db.t4g.small"
}
module "api" {
  source        = "../api"
  name          = local.name
  environment   = var.environment
  artifact_path = var.artifact_path
  database = var.enable_database ? {
    host       = module.database[0].host, resource_id = module.database[0].resource_id,
    subnet_ids = module.network[0].subnet_ids, security_group_id = module.network[0].lambda_security_group_id
  } : null
}
output "api_endpoint" { value = module.api.api_endpoint }
output "api_role_arn" { value = module.api.api_role_arn }
output "database_host" { value = var.enable_database ? module.database[0].host : null }
output "master_secret_arn" {
  value     = var.enable_database ? module.database[0].master_secret_arn : null
  sensitive = true
}
