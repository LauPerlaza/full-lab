output "s3_bucket_name" {
  value = aws_s3_bucket.s3_test.id
  # se usa try para listar los bucket?
}
output "bucket_arn" {
  value = aws_s3_bucket.s3_test.arn
}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}