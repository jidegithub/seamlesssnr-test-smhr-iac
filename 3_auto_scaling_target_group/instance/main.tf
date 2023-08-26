locals {
  # resource_name = trimsuffix(substr("${local.prefix}-server", 0, 32), "-")
  # ec2_ami           = data.aws_ami.ubuntu.id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

data "aws_availability_zones" "all" {}
resource "aws_launch_configuration" "server" {
  name_prefix = var.resource_name
  image_id      = var.ec2_ami #local.ec2_ami #ubuntu 18.04 AMI (HVM), SSD Volume Type
  instance_type = var.instance_type
  key_name = var.keypair_name
  security_groups             = var.security_groups
  associate_public_ip_address = var.associate_public_ip_address
  user_data = var.user_data

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "server" {
  launch_configuration = aws_launch_configuration.server.name
  # availability_zones   = data.aws_availability_zones.all.names
  name_prefix = "${var.resource_name}-asg"
  target_group_arns    = var.target_group_arn

  min_size         = var.min_instance
  desired_capacity = var.desired_capacity
  max_size         = var.max_instance

  health_check_type = "ELB"
  metrics_granularity = "1Minute"
  vpc_zone_identifier = var.public_subnets

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = var.resource_name
    propagate_at_launch = true
  }
}