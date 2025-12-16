locals {
  rds_secret = jsondecode(aws_secretsmanager_secret_version.rds_credentials_version.secret_string)
}