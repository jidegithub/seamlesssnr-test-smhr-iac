module "s3_bucket" {
  source  = "cloudposse/lb-s3-bucket/aws"
  version = "~> 0.16.0"

  name                     = "${local.prefix}-${local.resource_name}-alb-logs"
  access_log_bucket_name   = "${local.prefix}-${local.resource_name}-alb-logs"
  access_log_bucket_prefix = "${local.resource_name}_${local.prefix}"
  force_destroy            = true
  # force_destroy_enabled    = true
}