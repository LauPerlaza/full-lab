module "networking-test" {
  source      = "./modules/networking"
  Environment = var.environment
  ip          = "181.63.51.122/32"
  region      = var.region
}

resource "aws_security_group" "allow_tls" {
  depends_on  = [module.networking-test]
  name        = "allow_tls"
  description = "aws_security_group"
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
  depends_on    = [aws_security_group.allow_tls, module.networking-test]
  source        = "./modules/ec2"
  instance_type = var.environment == "production" ? "m5.large" : "t2.micro"
  subnet_id     = module.networking-test.subnet_id_public2
  sg_ids        = [aws_security_group.allow_tls.id]
  name          = "ec2_test"
  environment   = var.environment
}

## usando Data statement para obtener el CIDR de la vpc creada, este CIDR va a ser usado en el grupo de seguridad de la RDS, 
## lo que va a permitir el acceso todas las IPs dentro del CIDR

data "aws_vpc" "vpc_cidr" {
  id = module.networking-test.vpc_id
}

module "rds_test" {
  source            = "./modules/rds"
  environment       = var.environment
  engine            = "mysql"
  engine_version    = "5.7"
  user-name         = "laup"
  multi_az          = var.environment == "prod" ? "true" : "false"
  availability_zone = "us-east-1a"
  name              = "rds_test"
  vpc_id            = module.networking-test.vpc_id
  subnet_ids        = [module.networking-test.subnet_id_public1, module.networking-test.subnet_id_public2]
  instance_class    = var.environment == "develop" ? "db.t2.medium" : "db.t2.micro"
  cidr_to_allow     = data.aws_vpc.vpc_cidr.cidr_block
  enable_bucket_policy = var.environment == "develop" ? "false" : "true"
}
# aws_encryption 

module "s3_test" {
  source           = "./modules/s3"
  environment      = var.environment
  region           = "us-east-1"
  bucket_name      = "bucket-s3-test-${random_string.backup_test.result}"
  encrypt_with_kms = var.environment == "prod" ? "true" : false
  kms_arn          = data.aws_s3_bucket.s3_test.arn

}
