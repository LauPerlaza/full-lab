#   #   # aws RDS INSTANCE #  #   #

resource "aws_db_instance" "rds-test" {
  allocated_storage    = 10
  db_name              = "rds-${var.name}-${var.environment}"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = Var.environment == “develop” ? “t2.medium” : “t2.micro
  username             = var.user-name
  password             = var.password
  vpc_security_group_ids = aws_vpc.security_group.ids
  db_subnet_group_name = "subnet-group-rds-${var.environment}"
  port = 3346
  availability_zone = var.availability_zone
  multi_az = var.multi_az
}

#   #   # AWS SECURITY GROUP #  #   #
resource "aws_security_group" " sg-rds" {
  name        = "sg-rds"
  description = "security-group-rds"
  vpc_id      = aws_vpc.my_vpc.id
  ingress {
    from_port   = 3346
    to_port     = 3346
    protocol    = "tcp"
    cidr_blocks = ["${var.ip}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "security-gruop-rds-${var.Environment}"
  }
}
#   #   # AWS SUBNET GROUP #  #   #
resource "aws_db_subnet_group" "subnet-group" {
  name       = "subnet-group-rds"
  subnet_ids = module.networking.subnet_id_public1

  tags = {
    Name = "subnet-group-rds-${var.environment}"
  }
} 