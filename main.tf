module "controlplane-nodes" {
  source = "./modules/controlplane-node"

  name_prefix        = var.cp_name_prefix
  instance_type      = var.control_plane_instance_type
  ha_mode            = var.control_plane_ha_mode
  vpc_id             = var.vpc_id
  subnet_ids         = var.private_subnet_ids
  ami_id             = var.ami_id
  iam_profile_name   = aws_iam_instance_profile.ssm_profile.name
  node_disk_size_gb  = var.node_disk_size_gb
  aws_keypair_name   = aws_key_pair.aws_terraform_keypair.key_name
  security_group_ids = [aws_security_group.rancher_sg_allowall.id]
  cluster_token      = var.cluster_token
  rke2_server_dns    = var.rke2_server_dns
  lb_dns_name        = aws_lb.apiserver_lb.dns_name
  rke2_version       = var.rke2_version
  ssh_public_key     = tls_private_key.global_key.public_key_openssh
  ssh_key_filename   = local_sensitive_file.ssh_private_key_pem.filename
  rke2_registry      = var.rke2_registry
  carbide_username   = var.carbide_username
  carbide_password   = var.carbide_password
  tags               = local.actual_tags

  aws_access_key     = var.aws_access_key
  aws_secret_key     = var.aws_secret_key
  aws_session_token  = var.aws_session_token
  aws_region         = var.aws_region
}

module "worker" {
  source = "./modules/worker-node"

  name_prefix        = var.worker_name_prefix
  worker_count       = var.worker_count
  instance_type      = var.worker_instance_type
  vpc_id             = var.vpc_id
  subnet_ids         = var.private_subnet_ids
  ami_id             = var.ami_id
  iam_profile_name   = aws_iam_instance_profile.ssm_profile.name
  node_disk_size_gb  = var.node_disk_size_gb
  aws_keypair_name   = aws_key_pair.aws_terraform_keypair.key_name
  security_group_ids = [aws_security_group.rancher_sg_allowall.id]
  cluster_token      = var.cluster_token
  cp_main_ip         = module.controlplane-nodes.main_node_ip
  rke2_version       = var.rke2_version
  ssh_public_key     = tls_private_key.global_key.public_key_openssh
  ssh_key_filename   = local_sensitive_file.ssh_private_key_pem.filename
  rke2_registry      = var.rke2_registry
  carbide_username   = var.carbide_username
  carbide_password   = var.carbide_password
  tags               = local.actual_tags

  aws_access_key     = var.aws_access_key
  aws_secret_key     = var.aws_secret_key
  aws_session_token  = var.aws_session_token
  aws_region         = var.aws_region
}