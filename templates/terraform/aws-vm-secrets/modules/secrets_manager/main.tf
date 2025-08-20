# Secret for EC2 credentials
resource "aws_secretsmanager_secret" "ec2_credentials" {
  name                    = "${var.secret_name_prefix}-ec2-credentials-${var.random_suffix}"
  description             = "EC2 instance credentials"
  recovery_window_in_days = 7

  tags = merge(var.common_tags, {
    Name = "${var.secret_name_prefix}-ec2-credentials"
  })
}

resource "aws_secretsmanager_secret_version" "ec2_credentials" {
  secret_id = aws_secretsmanager_secret.ec2_credentials.id
  secret_string = jsonencode({
    username = var.ec2_username
    password = var.ec2_password
  })
}

# Secret for S3 bucket information
resource "aws_secretsmanager_secret" "s3_bucket_info" {
  name                    = "${var.secret_name_prefix}-s3-bucket-info-${var.random_suffix}"
  description             = "S3 bucket information"
  recovery_window_in_days = 7

  tags = merge(var.common_tags, {
    Name = "${var.secret_name_prefix}-s3-bucket-info"
  })
}

# Secret for application configuration
resource "aws_secretsmanager_secret" "app_config" {
  name                    = "${var.secret_name_prefix}-app-config-${var.random_suffix}"
  description             = "Application configuration secrets"
  recovery_window_in_days = 7

  tags = merge(var.common_tags, {
    Name = "${var.secret_name_prefix}-app-config"
  })
}

resource "aws_secretsmanager_secret_version" "app_config" {
  secret_id = aws_secretsmanager_secret.app_config.id
  secret_string = jsonencode({
    database_url = "placeholder-for-database-url"
    api_key      = "placeholder-for-api-key"
    jwt_secret   = "placeholder-for-jwt-secret"
  })
}

# Secret for database credentials (for future use)
resource "aws_secretsmanager_secret" "database_credentials" {
  name                    = "${var.secret_name_prefix}-db-credentials-${var.random_suffix}"
  description             = "Database credentials"
  recovery_window_in_days = 7

  tags = merge(var.common_tags, {
    Name = "${var.secret_name_prefix}-db-credentials"
  })
}

resource "aws_secretsmanager_secret_version" "database_credentials" {
  secret_id = aws_secretsmanager_secret.database_credentials.id
  secret_string = jsonencode({
    username = "dbadmin"
    password = "placeholder-password"
    endpoint = "placeholder-endpoint"
    port     = 3306
    dbname   = "myapp"
  })
}
