#   #   # aws RDS INSTANCE #  #   #

resource "aws_db_instance" "rds-test" {
  allocated_storage      = 10
  db_name                = var.name
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.db_instance_class
  username               = var.user-name
  password               = var.password
  vpc_security_group_ids = var.vpc_security_group
  db_subnet_group_name   = var.db_subnet_group
  port                   = 3346
  availability_zone      = var.availability_zone
  multi_az               = var.multi_az
}

#   #   # AWS SECURITY GROUP #  #   #
resource "aws_security_group" "seg-rds" {
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
  name       = "subg-rds"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "subnet-group-rds-${var.environment}"
  }
} 