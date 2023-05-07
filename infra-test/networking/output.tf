output "vpc_test" {
  value = aws_vpc.vpc_test.id
}
output "subnet_id_public1" {
  value = aws_subnet.sub-public1.id
}
output "subnet_id_public2" {
  value = aws_subnet.sub-public2.id
}