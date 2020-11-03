# Terraform configuration

# provider
provider "aws" {
  region = "us-west-2"
}

# S3 bucket for private content
module "s3_bucket_private_content" {
  source = "./modules/s3-bucket-private-content"

  for_each = var.private_buckets

  bucket_name = each.value.name
}


# CloudFront distribution for private content
module "cf_private_content" {
  source = "./modules/cloud-front-private-content"

  buckets         = module.s3_bucket_private_content
  private_buckets = var.private_buckets
}

# resource "null_resource" "s3_objects" {
#   provisioner "local-exec" {
#     command = "aws s3 cp modules/aws-s3-static-website-bucket/www/ s3://prazzy-static-website-11012020/ --recursive"
#   }
# }

# # S3 bucket for private content
# module "website_s3_bucket" {
#   source = "./modules/aws-s3-static-website-bucket"

#   bucket_name = "prazzy-static-website-11012020"

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

# resource "null_resource" "s3_objects" {
#   provisioner "local-exec" {
#     command = "aws s3 cp modules/aws-s3-static-website-bucket/www/ s3://prazzy-static-website-11012020/ --recursive"
#   }
# }
