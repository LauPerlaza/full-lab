module "networking-test" {
  source      = "./modules/networking"
  Environment = var.environment
  ip          = "181.63.51.122/32"
  region      = var.region
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.networking-test.vpc_id

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
  subnet_id     = module.networking-test.subnet_id_public2
  sg_ids        = [aws_security_group.allow_tls.id]
  name          = "ec2_test"
  environment   = var.environment
}
module "rds_test" {
  source            = "./modules/rds"
  environment       = var.environment
  engine            = "mysql"
  engine_version    = "5.7"
  user-name         = "laup"
  password          = "12345678"
  multi_az          = false
  availability_zone = "us-east-1a"
  name              = "rds_test"
  vpc_id            = module.networking-test.vpc_id
  subnet_ids        = [module.networking-test.subnet_id_public1, module.networking-test.subnet_id_public2]
  instance_class    = var.environment == "develop" ? "db.t2.medium" : "db.t2.micro"
}