
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  for_each = var.private_buckets
  comment = each.value.origin_access_identity_comment
}

data "aws_s3_bucket" "selected" {
  for_each = var.buckets  
  bucket = each.value.name
}

data "aws_iam_policy_document" "s3_policy" {
  for_each = var.buckets
  
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${each.value.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity[each.key].iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  for_each = var.buckets
  bucket = data.aws_s3_bucket.selected[each.key].id
  policy = data.aws_iam_policy_document.s3_policy[each.key].json
}

resource "aws_cloudfront_distribution" "s3_distribution" {  
  for_each = var.buckets

  origin {
    domain_name = data.aws_s3_bucket.selected[each.key].bucket_regional_domain_name
    origin_id   = each.value.name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity[each.key].cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = each.value.name

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

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}