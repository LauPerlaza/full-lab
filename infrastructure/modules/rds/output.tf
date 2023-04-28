output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
output "subnet_id_public1" {
  value = aws_subnet.public.id
}
output "vpc_security_group_ids" {
  value = aws_vpc.security_group.ids
}
