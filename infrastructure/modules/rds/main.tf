#   #   # aws RDS INSTANCE #  #   #

resource "aws_db_instance" "rds-test" {
  allocated_storage      = 10
  db_name                = var.name
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.environment == "develop" ? "db.t2.medium" : "db.t2.micro"
  username               = var.user-name
  password               = var.password
  vpc_security_group_ids = [aws_security_group.seg-rds.id]
  db_subnet_group_name   = aws_db_subnet_group.subnet-group-rds.name
  port                   = 3346
  availability_zone      = var.availability_zone
  multi_az               = var.multi_az
}

#   #   # AWS SECURITY GROUP #  #   #
resource "aws_security_group" "sg-rds" {
  name        = "seg-rds"
  description = "security-group-rds"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 3346
    to_port     = 3346
    protocol    = "tcp"
    cidr_blocks = [var.ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "security-gruop-rds-${var.environment}"
  }
}
#   #   # AWS SUBNET GROUP #  #   #
resource "aws_db_subnet_group" "subnet-group" {
  name       = "subnet-group-rds"
  subnet_ids = var.subnet-id

  tags = {
    Name = "subnet-group-rds-${var.environment}"
  }
} 