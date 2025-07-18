#################################
# VPC & インターネットゲートウェイ
#################################
resource "aws_vpc" "vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "laravel-apprunner-docker-vpc"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "laravel-apprunner-docker-internet-gateway"
  }
}

#################################
# パブリックサブネット & ルート
#################################
resource "aws_subnet" "subnet_public_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "laravel-apprunner-docker-subnet-public-1a"
  }
}

resource "aws_subnet" "subnet_public_1c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "laravel-apprunner-docker-subnet-public-1c"
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "laravel-apprunner-docker-public-rtb"
  }
}

resource "aws_route_table_association" "subnet_public_1a" {
  subnet_id      = aws_subnet.subnet_public_1a.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "subnet_public_1c" {
  subnet_id      = aws_subnet.subnet_public_1c.id
  route_table_id = aws_route_table.public_rtb.id
}

#################################
# プライベートサブネット & ルート
#################################
resource "aws_subnet" "subnet_private_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.10.0/24"
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name = "laravel-apprunner-docker-subnet-private-1a"
  }
}

resource "aws_subnet" "subnet_private_1c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.11.0/24"
  availability_zone       = "ap-northeast-1c"

  tags = {
    Name = "laravel-apprunner-docker-subnet-private-1c"
  }
}

resource "aws_route_table" "private_rtb_1a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "laravel-apprunner-docker-private-rtb-1a"
  }
}

resource "aws_route_table" "private_rtb_1c" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "laravel-apprunner-docker-private-rtb-1c"
  }
}

resource "aws_route_table_association" "subnet_private_1a" {
  subnet_id      = aws_subnet.subnet_private_1a.id
  route_table_id = aws_route_table.private_rtb_1a.id
}

resource "aws_route_table_association" "subnet_private_1c" {
  subnet_id      = aws_subnet.subnet_private_1c.id
  route_table_id = aws_route_table.private_rtb_1c.id
}

#################################
# セキュリティグループ（Private）
#################################
resource "aws_security_group" "private_sg" {
  name   = "private_sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups  = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "laravel-apprunner-docker-private-sg"
  }
}

#################################
# VPCエンドポイント（Secrets Manager）
#################################
resource "aws_vpc_endpoint" "sm_endpoint" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.secretsmanager"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.subnet_private_1a.id,
    aws_subnet.subnet_private_1c.id
  ]

  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.private_sg.id
  ]

  tags = {
    Name = "laravel-apprunner-docker-sm-endpoint"
  }
}

#################################
# EIP for NAT Gateway
#################################
resource "aws_eip" "nat_eip_1a" {
  domain = "vpc"
  tags = {
    Name = "laravel-apprunner-docker-nat-eip-1a"
  }
}

resource "aws_eip" "nat_eip_1c" {
  domain = "vpc"
  tags = {
    Name = "laravel-apprunner-docker-nat-eip-1c"
  }
}

#################################
# NAT Gateway
#################################
resource "aws_nat_gateway" "nat_1a" {
  allocation_id = aws_eip.nat_eip_1a.id
  subnet_id     = aws_subnet.subnet_public_1a.id

  tags = {
    Name = "laravel-apprunner-docker-nat-1a"
  }
}

resource "aws_nat_gateway" "nat_1c" {
  allocation_id = aws_eip.nat_eip_1c.id
  subnet_id     = aws_subnet.subnet_public_1c.id

  tags = {
    Name = "laravel-apprunner-docker-nat-1c"
  }
}

#################################
# NAT Gateway の関連付け
#################################
resource "aws_route" "private_nat_route_1a" {
  route_table_id         = aws_route_table.private_rtb_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1a.id
}

resource "aws_route" "private_nat_route_1c" {
  route_table_id         = aws_route_table.private_rtb_1c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1c.id
}