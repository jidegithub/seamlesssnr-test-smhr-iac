variable "security_groups" {
  type = list(string)
  description = "resource security groups"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "default instance type to use incase its omitted"
}

variable "aws_region" {
  default = "us-east-1"
  description = "resource deployment region"
}

variable "associate_public_ip_address" {
  default     = true
  description = "allow dhcp server to provide public ipv4 address to instance"
}

variable "ec2_ami" {
  default = "ami-0ee23bfc74a881de5"
  description = "ec2 instance amazon machine image"
}

variable "desired_capacity" {
  type = number
  default = 1
  description = "desired number of instance to provision"
}
variable "min_instance" {
  type = number
  default = 1
  description = "minimum number of instance to provision"
}

variable "max_instance" {
  type = number
  default = 5
  description = "maximum number of instance to provision"
}

variable "public_subnets" {
  type = list(string)
  description = "public subnets"
}

variable "target_group_arns" {
  type = list(string)
  description = "target group application resource network"
}
variable "user_data" {}
variable "resource_name" {}
variable "common_tags" {}
variable "keypair_name" {}

# variable "vpc_id" {}
# variable "subnet_id" {}

