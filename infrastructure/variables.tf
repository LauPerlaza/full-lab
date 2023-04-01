variable "region" {
  default     = "us-east-1"
  type        = string
  description = "Region of the VPC"
}
variable "Environment" {
   type = string
   description = "dev" 
}
variable "cidr_blocks" {
type = number
description = "ip"
}
