# VPC resources: This will create 1 VPC with 4 Subnets, 1 Internet Gateway, 1 Route Table.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}
provider "aws" {
region = var.region
  shared_credentials_file = "~/.aws/credentials"
}
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
    Name = "vpc-public-lab-full"
    Environment = "dev"
  }
}
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
   tags = {
    Name = "subnet-public1-lab-full"
  }
  }
  resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
   tags = {
    Name = "subnet-public2-lab-full"
   }
  }
  resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1a"
   tags = {
    Name = "subnet-private1-lab-full"
   }
  }
  resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
   tags = {
    Name = "subnet-private2-lab-full"
   }
   }
   resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "internet-gateway-lab-full"
  }
  }
  resource "aws_route_table" "my_vpc_us_east_1a_public" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_vpc_igw.id
    }
    tags = {
        Name = "route-table-lab-full"
    }
}
resource "aws_route_table_association" "my_vpc_us_east_1a_public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.my_vpc_us_east_1a_public.id
}
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_sg"
  description = "security-group-terraform"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["67.73.233.174/32"]
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
    Name = "security-gruop-lab-full"
  }
}
