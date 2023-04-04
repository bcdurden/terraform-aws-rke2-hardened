output "main_instance_id" {
  value = aws_instance.rancher_server_main.id
}
output "ha_instance_ids" {
  value = var.ha_mode ? [for i in aws_instance.rancher_server_ha : i.id]: null
}
output "main_node_ip" {
  value = aws_instance.rancher_server_main.private_ip
}