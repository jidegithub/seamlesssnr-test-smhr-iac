locals {
  resource_name = trimsuffix(substr("${local.prefix}-logs", 0, 32), "-")
}
# ------------ Create AWS ALB Security Group -----------
module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.16.0"

  name                = "${local.prefix}-alb-sg"
  description         = "Security group for ALB"
  vpc_id              = local.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp", "http-8080-tcp"]
  egress_rules        = ["all-all"]
}

# ------------ Create AWS ALB -----------
resource "aws_lb" "web" {
  name = "${local.prefix}-alb"
  # load_balancer_type         = "application"
  # internal                   = false
  subnets                    = local.public_subnets
  security_groups            = [module.alb_sg.security_group_id]
  enable_deletion_protection = false

  access_logs {
    bucket  = module.s3_bucket.bucket_id
    prefix  = local.resource_name
    enabled = true
  }

  tags = merge(
    {
      Name = "${local.prefix}-alb"
    },
    local.common_tags
  )
}