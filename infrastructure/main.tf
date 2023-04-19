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
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
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
  instance_type = "t2.micro"
  subnet_id     = module.networking.subnet_id_public1
  sg_ids        = [aws_security_group.allow_tls.id]
  name          = "ec2_test"
  environment   = var.environment
}