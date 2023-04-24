variable "environment" {
  type        = string
  description = "dev"
}
variable "sg_ids" {
  type = list(any)
}