variable "name" { type = string }
variable "subnet_ids" { type = list(string) }
variable "security_group_id" { type = string }
variable "production" { type = bool }
variable "instance_class" { type = string }
resource "aws_kms_key" "database" {
  description             = "${var.name} RDS storage/backups"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}
resource "aws_kms_key" "secret" {
  description             = "${var.name} RDS-managed administrator secret"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}
resource "aws_db_subnet_group" "this" {
  name       = var.name
  subnet_ids = var.subnet_ids
}
resource "aws_db_parameter_group" "this" {
  name_prefix = "${var.name}-"
  family      = "postgres17"
  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }
  parameter {
    name  = "log_statement"
    value = "none"
  }
  parameter {
    name  = "log_min_error_statement"
    value = "panic"
  }
  parameter {
    name  = "log_parameter_max_length_on_error"
    value = "0"
  }
  parameter {
    name  = "log_min_duration_statement"
    value = "-1"
  }
}
resource "aws_db_instance" "this" {
  identifier                          = var.name
  engine                              = "postgres"
  engine_version                      = "17"
  instance_class                      = var.instance_class
  allocated_storage                   = 20
  max_allocated_storage               = 50
  storage_type                        = "gp3"
  storage_encrypted                   = true
  kms_key_id                          = aws_kms_key.database.arn
  db_name                             = "noryva"
  username                            = "noryva_admin"
  manage_master_user_password         = true
  master_user_secret_kms_key_id       = aws_kms_key.secret.arn
  iam_database_authentication_enabled = true
  db_subnet_group_name                = aws_db_subnet_group.this.name
  vpc_security_group_ids              = [var.security_group_id]
  parameter_group_name                = aws_db_parameter_group.this.name
  publicly_accessible                 = false
  multi_az                            = var.production
  backup_retention_period             = var.production ? 35 : 1
  backup_window                       = "02:00-03:00"
  maintenance_window                  = "sun:03:30-sun:04:30"
  deletion_protection                 = var.production
  skip_final_snapshot                 = !var.production
  final_snapshot_identifier           = var.production ? "${var.name}-final-reviewed" : null
  copy_tags_to_snapshot               = true
  auto_minor_version_upgrade          = true
  allow_major_version_upgrade         = false
  apply_immediately                   = false
  performance_insights_enabled        = false
  monitoring_interval                 = 0
}
output "host" { value = aws_db_instance.this.address }
output "resource_id" { value = aws_db_instance.this.resource_id }
output "master_secret_arn" {
  value     = aws_db_instance.this.master_user_secret[0].secret_arn
  sensitive = true
}
