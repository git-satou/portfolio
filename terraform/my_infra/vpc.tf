resource "aws_vpc" "vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my_vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "my_igw"
  }
}

resource "aws_subnet" "subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name = "my-subnet-1a"
  }
}

resource "aws_subnet" "subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "ap-northeast-1c"

  tags = {
    Name = "my-subnet-1c"
  }
}

resource "aws_subnet" "subnet_1d" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.3.0/24"
  availability_zone       = "ap-northeast-1d"

  tags = {
    Name = "my-subnet-1d"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "my-rtb"
  }
}

resource "aws_route_table_association" "subnet_1a" {
  subnet_id      = aws_subnet.subnet_1a.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet_1c" {
  subnet_id      = aws_subnet.subnet_1c.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet_1d" {
  subnet_id      = aws_subnet.subnet_1d.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.route_table.id
  ]

  tags = {
    Name = "s3-gateway-endpoint"
  }
}