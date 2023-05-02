module "networking" {
  source      = "./modules/networking"
  Environment = var.environment
  ip          = "67.73.238.206/32"
  region      = var.region
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.networking.vpc_id

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
}
module "ec2_test" {
  source        = "./modules/ec2"
  instance_type = var.environment == "production" ? "m5.large" : "t2.micro"
  subnet_id     = module.networking.subnet_id_public1
  sg_ids        = [aws_security_group.allow_ssh.id]
  name          = "ec2_test"
  environment   = var.environment
}
module "rds_test" {
  source = "./modules/rds"
  environment = var.environment
  user-name = var.user-name
  password = var.password
  multi_az = var.multi_az
  instance_class = var.environment == "develop" ? "db.t2.medium" : "db.t2.micro"
  name = "rds_test"
  }