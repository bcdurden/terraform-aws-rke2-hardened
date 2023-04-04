output "worker_ids" {
    value = [for i in aws_instance.rancher_server_workers : i.id]
}