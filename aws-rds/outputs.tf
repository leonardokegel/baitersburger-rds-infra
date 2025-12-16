output "endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "secret_arn" {
  value = aws_secretsmanager_secret.rds_credentials.arn
}
