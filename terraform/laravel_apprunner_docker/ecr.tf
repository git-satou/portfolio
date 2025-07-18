resource "aws_ecr_repository" "ecr" {
  name                 = "laravel-apprunner-docker-ecr"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "laravel-apprunner-docker-ecr"
  }
}