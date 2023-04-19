output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
output "subnet_id_public1" {
  value = aws_subnet.public.id
}