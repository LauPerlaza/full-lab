#definicion de variables
variable "region" {
  default     = "us-east-1"
  type        = string
  description = "Region of the VPC"
}
variable "Environment" {
   type = string
   description = "dev"
}
variable "ip" {
type = string
description = "ip"
}
variable "instance_type" {
  default     = "t2.micro"
  description = "t2.micro"
}
