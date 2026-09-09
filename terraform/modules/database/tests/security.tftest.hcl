mock_provider "aws" {}
variables {
  name              = "noryva-test"
  subnet_ids        = ["subnet-a", "subnet-b"]
  security_group_id = "sg-test"
  production        = false
  instance_class    = "db.t4g.small"
}
run "staging_database" {
  command = plan
  assert {
    condition     = aws_db_instance.this.storage_encrypted && !aws_db_instance.this.publicly_accessible && aws_db_instance.this.iam_database_authentication_enabled
    error_message = "Database must be encrypted, private and IAM enabled."
  }
  assert {
    condition     = aws_db_instance.this.manage_master_user_password && aws_db_instance.this.password == null
    error_message = "RDS must manage the administrator secret."
  }
  assert {
    condition     = !aws_db_instance.this.multi_az && aws_db_instance.this.backup_retention_period == 1
    error_message = "Synthetic staging must not inherit production idle cost."
  }
}
run "production_database" {
  command = plan
  variables { production = true }
  assert {
    condition     = aws_db_instance.this.multi_az && aws_db_instance.this.deletion_protection && !aws_db_instance.this.skip_final_snapshot && aws_db_instance.this.backup_retention_period == 35
    error_message = "Production data protection settings are required."
  }
  assert {
    condition     = aws_kms_key.database.enable_key_rotation && aws_kms_key.secret.enable_key_rotation
    error_message = "Storage and secret keys must rotate."
  }
}
