
data "aws_s3_bucket" "selected" {
  bucket = var.bucket.name
}

resource "aws_cloudfront_distribution" "s3_distribution" {  

  origin {
    domain_name = data.aws_s3_bucket.selected.bucket_regional_domain_name
    origin_id   = var.bucket.name
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket.name

    forwarded_values {
      query_string = true
      query_string_cache_keys = ["delimiter", "prefix"]  
      headers      = ["Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}