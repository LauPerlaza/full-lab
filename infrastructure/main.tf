# 	VPC resources: This will create 1 VPC with 4 Subnets, 1 Internet Gateway, 1 Route Table and 1 Ec2
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}
#   #   # AWS PROVIDER #  #   #
provider "aws" {
region = var.region
  shared_credentials_files = ["~/.aws/credentials"]
}
#   #   # AWS VPC #  #   #
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
    Name = "vpc-public-lab-${var.Environment}"
    Environment = "var.Environment"
  }
  }
#   #   # AWS SUBNETS PUBLIC #  #   #
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "${var.region}a"
   tags = {
    Name = "subnet-public1-${var.Environment}"
  }
  }
  resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}b"
   tags = {
    Name = "subnet-public2-${var.Environment}"
   }
  }
#   #   # AWS SUBNETS PRIVATE #  #   #
  resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.region}a"
   tags = {
    Name = "subnet-private1-${var.Environment}"
   }
  }
  resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "${var.region}a"
   tags = {
    Name = "subnet-private2-${var.Environment}"
     }
   }
  #   #   # AWS INTERNET GATEWAY #  #   #
   resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "internet-gateway-${var.Environment}"
    }
  }
  #   #   # AWS ROUTE TABLE #  #   #
  resource "aws_route_table" "my_vpc_us_east_1a_public" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_vpc_igw.id
    }
    tags = {
        Name = "route-table-lab-${var.Environment}"
  }
}
#   #   # AWS ROUTE TABLE ASSOCIATION#  #   #
resource "aws_route_table_association" "my_vpc_us_east_1a_public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.my_vpc_us_east_1a_public.id
}
#   #   # AWS SECURITY GROUP #  #   #
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "security-group-terraform"
  vpc_id = aws_vpc.my_vpc.id
 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ip}"]
  }
ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name = "security-gruop-full-lab-${var.Environment}"
  }
}
#   #   # AWS EC2 #  #   #
resource "aws_instance" "my_instance" {
    ami = "ami-07a92b65064ead2f2"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]
    associate_public_ip_address = true
    subnet_id = aws_subnet.public.id
    tags = {
    Name = "instance-full-lab-${var.Environment}"
  }
}
