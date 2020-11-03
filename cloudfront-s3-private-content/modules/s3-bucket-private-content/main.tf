# Terraform configuration

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = [""]
    expose_headers  = [""]
  }
}
