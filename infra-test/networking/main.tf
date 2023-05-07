# VPC TEST #
resource "aws_vpc" "vpc_test" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "vpc_test-${var.environment}"
        Environment = "${var.environment}"
    }
  }

# AWS SUBNETS PUBLIC #
resource "aws_subnet" "sub-public1" {
    vpc_id = aws_vpc.vpc_test.id 
    cidr_block = "10.0.1.0/24"
    availability_zone = "${var.region}a"
    tags = {
        Name = "sub_public1-${var.environment}"
    }
}
resource "aws_subnet" "sub-public2" {
    vpc_id = aws_vpc.vpc_test.id 
    cidr_block = "10.0.2.0/24"
    availability_zone = "${var.region}a"
    tags = {
        Name = "sub_public1-${var.environment}"
    }
}
# AWS SUBNETS PRIVATE
resource "aws_subnet" "sub-private1" {
    vpc_id = aws_vpc.vpc_test.id 
    cidr_block = "10.0.3.0/24"
    availability_zone = "${var.region}a"
    tags = {
        Name = "sub_private1-${var.environment}"
    }
}
resource "aws_subnet" "sub-private2" {
    vpc_id = aws_vpc.vpc_test.id 
    cidr_block = "10.0.3.0/24"
    availability_zone = "${var.region}a"
    tags = {
        Name = "sub_private2-${var.environment}"
    }
}
# AWS INTERNET GATEWAY #
resource "aws_internet_gateway" "itg-test" {
    vpc_id = aws_vpc.vpc_test.id
    tags = {
        Name = "itg-test-${var.environment}"
    }
}
# AWS ROUTE TABLE #
resource "aws_route_table" "rt-test" {
    vpc_id = aws_vpc.vpc_test.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.itg-test.id
    }
    tags = {
        Name = "rt-test-${var.environment}"
    }
}
# AWS ROUTE TABLE ASSOCIATION #
resource "aws_route_table_association" "rt-association" {
    subnet_id = aws_subnet.sub-public1.id
    route_table_id = aws_route_table.rt-association.id 
}
# AWS SECURITY GROUP #
resource "aws_security_group" "secg-test" {
  name        = "secg-test"
  description = "security-group-test"
  vpc_id      = aws_vpc.vpc_test.id
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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "secg-test-${var.environment}"
  }
}

