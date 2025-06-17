resource "aws_instance" "example_com" {
  ami           = "ami-08b12a33819fa5d75"
  subnet_id     = aws_subnet.subnet_1a.id
  key_name      = "ec2-user"
  instance_type = "t3a.small"

  iam_instance_profile = aws_iam_instance_profile.s3_access_profile.name
  vpc_security_group_ids = [aws_security_group.ec2.id]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    "Name" = "example.com"
    "Snapshot" = "True"
  }
}

# SG
data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

resource "aws_security_group" "ec2" {
  name        = "ec2"
  description = "Security group for EC2"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2"
  }
}

resource "aws_security_group_rule" "ec2_ingress_local" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "ec2_ingress_home" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["*.*.*.*/32"]
  security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group_rule" "ec2_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront.id]
  security_group_id = aws_security_group.ec2.id
}