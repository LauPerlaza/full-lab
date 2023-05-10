#   #   # AWS S3 #     #    #
resource "aws_s3_bucket" "s3_test" {
  bucket = var.bucket_name
  region = var.region
  force_destroy = false 
  acl = var.acl 
  policy = aws_iam_policy.policy_test.id
  
    versioning {
    enabled = true 
  }
  tags = {
    Name        = "s3_test"
    Environment = var.environment
  }
}
resource "aws_iam_policy" "policy_test" {
  name =  "policy_test"
  description = "policy_test"
  policy = jsonencode ({
      "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:List*",
                "s3:ListAllMyBuckets"
            ],
            "Resource": "*"
        },
    ]
})
 tags = {
    Name        = "policy_test"
    Environment = var.environment
  }
  
}