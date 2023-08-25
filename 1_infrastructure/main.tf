locals {
  prefix   = "seamless"
  vpc_name = "${local.prefix}-vpc"
  vpc_cidr = "10.10.0.0/16"
  common_tags = {
    Environment = "prod"
    Project     = "seamless-snr"
  }
}
