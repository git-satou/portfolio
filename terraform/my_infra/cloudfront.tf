# ACM
resource "aws_acm_certificate" "example" {
  provider                  = aws.us_east_1
  domain_name               = "*.example.com"
  subject_alternative_names = ["example.com"]
  validation_method         = "DNS"
}

# 関数
resource "aws_cloudfront_function" "referer_check" {
  name    = "referer-check"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = file("${path.module}/referer-check.js")
}

resource "aws_cloudfront_function" "basic_auth" {
  name    = "basic-auth"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = file("${path.module}/basic-auth.js")
}

# キャッシュポリシー
resource "aws_cloudfront_cache_policy" "custom_policy" {
  name        = "CustomCachingOptimized"
  min_ttl     = 1
  default_ttl = 2592000
  max_ttl     = 31536000

  parameters_in_cache_key_and_forwarded_to_origin {
    headers_config {
      header_behavior = "whitelist"

      headers {
        items = ["Authorization", "Host"]
      }
    }

    cookies_config {
      cookie_behavior = "all"
    }

    query_strings_config {
      query_string_behavior = "all"
    }
    
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
  }
}

# OAC
resource "aws_cloudfront_origin_access_control" "s3_origin_wp_media" {
  name                              = "s3-origin-wp-media"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# cloudfront ex1
resource "aws_cloudfront_distribution" "ex1" {
  enabled = true

  origin {
    domain_name = "origin-ex1.example.com"
    origin_id   = "origin-ex1.example.com"
    connection_attempts      = 3
    connection_timeout       = 10

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_keepalive_timeout = 5
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  origin {
    domain_name = "${aws_s3_bucket.wp_media.bucket}.s3.ap-northeast-1.amazonaws.com"
    origin_id   = "s3-wp-media-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_origin_wp_media.id
  }

  default_cache_behavior {
    target_origin_id       = "origin-ex1.example.com"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]

    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.basic_auth.arn
    }

    compress = true
  }

  ordered_cache_behavior {
    path_pattern     = "wp-content/uploads/*"
    target_origin_id       = "s3-wp-media-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    cache_policy_id = "72f9fd36-fd7b-4afa-a373-edb7a28bbbe2"

    compress = true
  
    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.referer_check.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }   

  aliases = ["ex1.example.com"]

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.example.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }
}

