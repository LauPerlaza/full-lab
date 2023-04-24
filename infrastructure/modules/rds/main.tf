resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "lauperlaza"
  password             = "lauperlaz@123*"
  vpc_security_group_ids =  var.sg_ids
  db_subnet_group_name = var.subnet-group 
  port = 3346
  availability_zone = "us-east-1"
  multi_az = 
}
resource "aws_db_subnet_group" "subnet-group" {
  name       = "subnet-group"
  subnet_ids = module.networking.public_subnets

  tags = {
    Name = "subnet-group-${var.environment}"
  }
}