locals {
  s3_origin_id = aws_s3_bucket.website_bucket.bucket_regional_domain_name
}

resource "aws_cloudfront_origin_access_identity" "origin_access" {
  comment = local.s3_origin_id
}

data "aws_cloudfront_cache_policy" "cache_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "distribution" {
  comment             = null
  default_root_object = null
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  tags                = local.common_tags
  wait_for_deployment = true

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 404
    response_page_path    = "/404.html"
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cache_policy_id = data.aws_cloudfront_cache_policy.cache_optimized.id
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    default_ttl = 0
    max_ttl     = 0
    min_ttl     = 0

    target_origin_id       = local.s3_origin_id
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.http_redirect.arn
    }

  }

  origin {
    domain_name = local.s3_origin_id
    origin_id   = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_function" "http_redirect" {
  code    = file("s3_policies/cloudfront_function.js")
  comment = null
  name    = "http_redirect"
  publish = null
  runtime = "cloudfront-js-2.0"
}
