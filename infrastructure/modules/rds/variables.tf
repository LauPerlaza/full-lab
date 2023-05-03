variable "environment" {
  type = string
}
variable "user-name" {
  type = string
}
variable "password" {
  type        = string
  description = "password user rds"
}
variable "multi_az" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "db_name" {
  type = string
}
variable "availability_zone" {
  type = string
}
variable "db_instance_class" {
  type = string
}
variable "subnet-id" {
  type = string
}
