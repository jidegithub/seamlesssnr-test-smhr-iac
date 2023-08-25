locals {
  aws_region = "us-east-1"
  prefix     = "seamless-sre-remote-state"
  ssm_prefix = "/org/seamless/terraform"
  common_tags = {
    Project   = "seamless"
    ManagedBy = "Terraform"
  }
}
