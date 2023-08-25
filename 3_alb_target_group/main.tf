locals {
  remote_state_bucket_region = "us-east-1"
  remote_state_bucket        = "seamless-sre-remote-state-s3"
  infrastructure_state_file  = "seamless-infrastructure.tfstate"
  alb_state_file             = "seamless-alb.tfstate"

  prefix          = data.terraform_remote_state.infrastructure.outputs.prefix
  common_tags     = data.terraform_remote_state.infrastructure.outputs.common_tags
  vpc_id          = data.terraform_remote_state.infrastructure.outputs.vpc_id
  public_subnets  = data.terraform_remote_state.infrastructure.outputs.public_subnets
  private_subnets = data.terraform_remote_state.infrastructure.outputs.private_subnets
  # magento_server_autoscaling_group_id = data.terraform_remote_state.instance.outputs.magento-server_autoscaling_group_id
  # varnish_server_autoscaling_group_id = data.terraform_remote_state.instance.outputs.varnish-server_autoscaling_group_id
}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    bucket = local.remote_state_bucket
    region = local.remote_state_bucket_region
    key    = local.infrastructure_state_file
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = local.remote_state_bucket
    region = local.remote_state_bucket_region
    key    = local.alb_state_file
  }
}