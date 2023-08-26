# output "magento-server_autoscaling_group_id" {
#   value = module.magento-server.group_server_id
# }

output "security_group_id" {
  value = module.private_instance_sg.security_group_id
}