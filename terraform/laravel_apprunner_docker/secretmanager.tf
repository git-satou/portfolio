## Laravel
resource "aws_secretsmanager_secret" "app_key" {
  name = "laravel-apprunner-docker-app-key"
}

## RDS
resource "aws_secretsmanager_secret_version" "app_key" {
  secret_id     = aws_secretsmanager_secret.app_key.id
  secret_string = "base64:XxuC/ZM*********************************"
}

resource "aws_secretsmanager_secret" "rds_user" {
  name = "laravel-apprunner-docker-rds-user"
}

resource "aws_secretsmanager_secret_version" "rds_user" {
  secret_id     = aws_secretsmanager_secret.rds_user.id
  secret_string = "admin"
}

resource "aws_secretsmanager_secret" "rds_password" {
  name = "laravel-apprunner-docker-rds-password"
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = "*************"
}