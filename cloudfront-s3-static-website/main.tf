# Terraform configuration

# provider
provider "aws" {
  region = "us-west-2"
}

# S3 bucket for static website
module "s3_bucket_website" {
  source = "./modules/s3-static-website-bucket"

  bucket_name = var.bucket_name
}

# Copy static website code
resource "null_resource" "s3_objects" {
  provisioner "local-exec" {
    command = "aws s3 cp modules/s3-static-website-bucket/www/ s3://${var.bucket_name}/ --recursive"
  }
}

# # CloudFront distribution
module "cf_private_content" {
  source = "./modules/cloud-front-distribution"

  bucket = module.s3_bucket_website
}
