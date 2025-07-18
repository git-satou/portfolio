#################################
# RDS Aurora MySQL serverless v2
#################################
resource "aws_db_subnet_group" "db_subnet" {
  name       = "laravel-apprunner-docker-db_subnet_group"
  subnet_ids = [
    aws_subnet.subnet_private_1a.id,
    aws_subnet.subnet_private_1c.id
  ]

  tags = {
    Name = "laravel-apprunner-docker-db_subnet_group"
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier     = "laravel-apprunner-docker-cluster"
  engine                 = "aurora-mysql"
  engine_version         = "8.0.mysql_aurora.3.04.0"
  database_name          = "laravel"
  master_username        = "admin"
  master_password        = "***********"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 30
  }

  skip_final_snapshot = true

  tags = {
    Name = "laravel-apprunner-docker-cluster"
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier          = "laravel-apprunner-docker-instance"
  cluster_identifier  = aws_rds_cluster.aurora_cluster.id
  instance_class      = "db.serverless"
  engine              = "aurora-mysql"
  engine_version      = "8.0.mysql_aurora.3.04.0"
  publicly_accessible = false

  tags = {
    Name = "laravel-apprunner-docker-instance"
  }
}