output "s3_bucket_name" {
  value = try(aws_s3_bucket.s3_test.id, "")
  # se usa try para listar los bucket?
}
output "bucket_arn" {
  value = try(aws_s3_bucket.s3_test.arn, "")
}