resource "aws_security_group" "web" {
  name        = "laravel-apprunner-docker-web-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "laravel-apprunner-docker-web-sg"
  }
}

resource "aws_apprunner_vpc_connector" "vpc_connector" {
  vpc_connector_name = "laravel-apprunner-docker-vpc-connector"

  subnets         = [
    aws_subnet.subnet_private_1a.id,
    aws_subnet.subnet_private_1c.id
  ]

  security_groups = [aws_security_group.web.id]
}

resource "aws_apprunner_service" "web" {
  service_name = "laravel-apprunner-docker"

  source_configuration {
    authentication_configuration {
      access_role_arn = "arn:aws:iam::161848874613:role/service-role/AppRunnerECRAccessRole"
    }

    auto_deployments_enabled = true

    image_repository {
      image_identifier      = "161848874613.dkr.ecr.ap-northeast-1.amazonaws.com/laravel-apprunner-docker-ecr:latest"
      image_repository_type = "ECR"

      image_configuration {
        port = "80"
        runtime_environment_variables = {
          APP_ENV         = "staging"
          APP_DEBUG       = "false"
          APP_URL         = "http://localhost"
          LOG_CHANNEL     = "stderr"
          DB_CONNECTION   = "mysql"
          DB_HOST         = aws_rds_cluster.aurora_cluster.endpoint
          DB_PORT         = "3306"
          DB_DATABASE     = "laravel"
          SESSION_DRIVER  = "file"
        }      
        runtime_environment_secrets = {
          APP_KEY         = aws_secretsmanager_secret.app_key.arn
          DB_USERNAME     = aws_secretsmanager_secret.rds_user.arn
          DB_PASSWORD     = aws_secretsmanager_secret.rds_password.arn
        }
      }
    }
  }

  instance_configuration {
    cpu               = "1024"
    memory            = "2048"
    instance_role_arn = aws_iam_role.apprunner_role.arn
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.vpc_connector.arn
    }
  }

  tags = {
    Name = "laravel-apprunner-docker"
  }
}