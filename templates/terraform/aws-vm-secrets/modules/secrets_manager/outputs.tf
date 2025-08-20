output "ec2_secret_arn" {
  description = "ARN of the EC2 credentials secret"
  value       = aws_secretsmanager_secret.ec2_credentials.arn
}

output "ec2_secret_id" {
  description = "ID of the EC2 credentials secret"
  value       = aws_secretsmanager_secret.ec2_credentials.id
}

output "s3_bucket_secret_arn" {
  description = "ARN of the S3 bucket info secret"
  value       = aws_secretsmanager_secret.s3_bucket_info.arn
}

output "s3_bucket_secret_id" {
  description = "ID of the S3 bucket info secret"
  value       = aws_secretsmanager_secret.s3_bucket_info.id
}

output "app_config_secret_arn" {
  description = "ARN of the application config secret"
  value       = aws_secretsmanager_secret.app_config.arn
}

output "app_config_secret_id" {
  description = "ID of the application config secret"
  value       = aws_secretsmanager_secret.app_config.id
}

output "database_secret_arn" {
  description = "ARN of the database credentials secret"
  value       = aws_secretsmanager_secret.database_credentials.arn
}

output "database_secret_id" {
  description = "ID of the database credentials secret"
  value       = aws_secretsmanager_secret.database_credentials.id
}
