#   #   # AWS S3 #     #    #
resource "random_string" "bucket_test" {
  special = false 
}
#local name bucket
locals {
  bucket_name = "bucket-s3-test-${var.bucket_name}-${var.environment}"
}

data "aws_caller_identity" "current" {
  id = arn:aws:iam::017333715993:user/laura.perlaza
  
}
data "aws_kms_key" "key_test" {
  id = aws_s3_bucket.s3_test.arn
}

# crea el bocket s3 
resource "aws_s3_bucket" "bucket_test" {
  count = 4
  bucket        = local.bucket_name
  force_destroy = false 

  tags = {
    Name        = "bucket-s3-test-${local.bucket_name}"
    Environment = var.environment
  }
}
  # acl bloque el acceso al bucket publico o privado
resource "aws_s3_bucket_ownership_controls" "acl_test" { 
  bucket = aws_s3_bucket.bucket_test[0].id 
  #por favor otro repaso
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "acl_test" {
  depends_on = [aws_s3_bucket_ownership_controls.acl_test]

  bucket = aws_s3_bucket.bucket_test.id 
  acl    = "private" 
}
#pero si es "PUBLIC" como poner esa variable
# resource "aws_s3_bucket_public_access_block" "acl_test {
  #bucket = aws_s3_bucket.bucket_test.id

  #block_public_acls       = false
  #block_public_policy     = false
  #ignore_public_acls      = false
  #restrict_public_buckets = false
#}

#resource "aws_s3_bucket_ownership_controls" "acl_test" {
 # bucket = aws_s3_bucket.bucket_test.id
  #rule {
   # object_ownership = "BucketOwnerPreferred"
  #}
#}

#resource "aws_s3_bucket_acl" "acl_test" {
 # depends_on = [
	#aws_s3_bucket_public_access_block.acl_test,
	#aws_s3_bucket_ownership_controls.acl_test,
  #]

  #bucket = aws_s3_bucket.acl_test.id
  #acl    = "public-read"
#}

resource "aws_kms_key" "key_test" {
  description             = "encrypt_bucket_objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption_kms" {
  coutn = var.encrypt_with_kms ? 1 : 0
   #por favor otra explicacion 
  bucket = aws_s3_bucket.bucket_test.id 
  # o .bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.key_test.arn 
      #var.kms_arn falta  output
      sse_algorithm     = "aws:kms" 
      # hay dos validos AES256 y aws:kms como se diferencian?
    }
  }
}
# aws_encryption_deffault
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption_aes" {
count = var.encrypt_with_kms ? 0 : 1 
#preguntar
bucket = aws_s3_bucket.bucket_test.id 
# o .bucket

rule {
  apply_server_side_encryption_by_default {
    sse_algorithm     = "AES256"

}
}
}

# access_from_another_account = s3_policy 
resource "aws_s3_bucket_policy" "s3_policy" {
  count = var.enable_bucket_policy ? 1 : 0 
  # leer ##########
   bucket = aws_s3_bucket.bucket_test.id
   # o .bucket
  policy = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
       # el arn del usuario?? 
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.bucket_test.arn,
      "${aws_s3_bucket.bucket_test.arn}/*",
      #no entiendo esto
    ]
  }
}