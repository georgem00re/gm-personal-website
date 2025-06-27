
resource "aws_cloudfront_distribution" "this" {

  // Allow the CloudFront distribution to accept end user requests for content.
  enabled = true

  // When an end user requests the root URL, we want to return index.html.
  default_root_object = "index.html"

  origin {
    origin_id                = var.s3_bucket_id
    domain_name              = var.s3_bucket_regional_domain_name
    origin_access_control_id = var.origin_access_control_id
  }

  default_cache_behavior {
    target_origin_id = var.s3_bucket_id

    // Ensures clients using HTTP are automatically redirected to HTTPS.
    viewer_protocol_policy = "redirect-to-https"

    // Defines what HTTP methods CloudFront accepts from clients.
    allowed_methods = ["GET", "HEAD"]

    // Specifies which HTTP methods CloudFront will cache responses for.
    cached_methods = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    // Time-to-live (TTL) defines how long content is cached at CloudFront edge locations (in seconds).
    min_ttl     = 0     // CloudFront can immediately check with the origin for updated content if caching rules allow it
    default_ttl = 3600  // CloudFront will cache the content for 1 hour by default.
    max_ttl     = 86400 // CloudFront will never cache the content for more than 24 hours.
  }

  // Enable clients to connect to the CloudFront distribution using a default SSL/TLS certificate.
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  // Prevent clients from sending IPv6 traffic to the CloudFront distribution.
  is_ipv6_enabled = false

  restrictions {
    geo_restriction {

      // Do not restrict access to the CloudFront distribution based on the client's geographic location.
      restriction_type = "none"
    }
  }

  // This determines which edge locations are used to serve your content. PriceClass_All tells CloudFront to use all
  // available edge locations worldwide to deliver your content.
  price_class = "PriceClass_All"
}
