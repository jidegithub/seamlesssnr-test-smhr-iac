locals {
  remote_state_bucket_region = "us-east-1"
  remote_state_bucket        = "seamless-sre-remote-state-s3"
  infrastructure_state_file  = "seamless-infrastructure.tfstate"
  alb_state_file             = "seamless-alb.tfstate"

  prefix         = data.terraform_remote_state.infrastructure.outputs.prefix
  common_tags    = data.terraform_remote_state.infrastructure.outputs.common_tags
  vpc_id         = data.terraform_remote_state.infrastructure.outputs.vpc_id
  public_subnets = data.terraform_remote_state.infrastructure.outputs.public_subnets

  alb_security_group_id             = data.terraform_remote_state.alb.outputs.alb_security_group_id
  public_instance_security_group_id = aws_security_group.public_instance_sg.id
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

module "web-server" {
  source          = "./instance"
  ec2_ami         = "ami-0ee23bfc74a881de5"
  security_groups = [module.private_instance_sg.security_group_id]
  instance_type   = "t2.micro"
  user_data       = filebase64("./templates/userdata.tpl")
  keypair_name    = aws_key_pair.scandy.key_name
  resource_name   = trimsuffix(substr("${local.prefix}-web-server", 0, 32), "-")

  #autoscaling
  min_instance     = 2
  desired_capacity = 2
  max_instance     = 5
  public_subnets   = local.public_subnets
  common_tags      = local.common_tags
}

resource "aws_instance" "bastion_server" {
  ami                    = "ami-0ee23bfc74a881de5"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.scandy.key_name
  vpc_security_group_ids = [local.public_instance_security_group_id]
  subnet_id              = local.public_subnets[0]
  user_data              = filebase64("./templates/userdata.tpl")

  tags = merge(
    {
      Name = "${local.prefix}-bastion-server"
    },
    local.common_tags
  )
}

resource "aws_security_group" "public_instance_sg" {
  name        = "${local.prefix}-pub-server-sg"
  description = "Security group for public web servers"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public_instance_sg"
  }
}

module "private_instance_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.16.0"

  name         = "${local.prefix}-priv-server-sg"
  description  = "Security group for private web servers"
  vpc_id       = local.vpc_id
  egress_rules = ["all-all"]

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = local.public_instance_security_group_id
    },
    {
      rule                     = "http-80-tcp"
      source_security_group_id = local.alb_security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 2
  computed_ingress_with_self = [{
    rule = "all-icmp"
  }]
  number_of_computed_ingress_with_self = 1
}

resource "aws_key_pair" "scandy" {
  key_name   = "scandy"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDtzXxbKlUMP6eZGOo/J1RBOJMb7LaRENGDusc0sjB+EzwjxSwZAtqyMuWofi1taJBQP391lfBqEIN1d0zuP54095zymQfyNzdxdgUl8Bi4XCFghW8n0TI/xybQ/IFUAHUxdXciZgd+9LWAF04aebMYk21WN9bq02tX8JmzahCtA8w8vqcEYCFQ3JyfDDYU7E2VbX+GXMZd7RLuWEDmr+yuL6TUUMhqD3drNwgtI6jSjukkbTaiQcT3a4FvQzqmEzjPr3E9sz1x7fnp6CU5/UPpi8QAk88FlN6m6vb1W+Ts3Fj44Jw0Xxjx7BOyXLucYIwwxsuL6+n3QtActWAdhcE7UyznjvrY63Bz7rO4F8kovsF1B3pBKrEajTTo7Qh3BvXPrwfpVDOh5i9/0b63etzNegduvzuibzkKBJKltxAtmFlQBPWw3P8p7LZXLslWmZON+vIpZ/zEgKyKAqbzId1x2UrjObTSep71v4NV52tQ9SRwA8kEEN6ez9VPgfLhl2XIX/ThsTFq044uV0Ool1GFzY18zJTe8HbyO9O5NqaGVHtMoQ8tCp8n2GnY6Z7gJWNZG74c43y9WefzDWFgKIk8tXkT9pwIQFgjpRLHLc1OmrTxP8M8jwlWiR09iS0c6rm3PJJoHGFbZUJ2N7h1I4+VtOdg0AiTBR0rRAgVTb67w== jide@jide-Precision-5510"
}