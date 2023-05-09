resource "aws_instance" "instance-full-lab" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = "keyec2terraform"

  vpc_security_group_ids = var.sg_ids

  tags = {
    Name        = "ec2-${var.name}-${var.environment}"
    Environment = var.environment
    CreatedBy   = "terraform"
  }
}
