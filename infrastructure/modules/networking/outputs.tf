output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
output "subnet_id_public1" {
  value = aws_subnet.public1.id
}
output "subnet_id_public2" {
  value = aws_subnet.public2.id
}
output "subnet_id_private1" {
  value = aws_subnet.private1.id
}
