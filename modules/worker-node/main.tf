resource "aws_instance" "rancher_server_workers" {
  count = var.worker_count
  depends_on = [
    aws_lb.apiserver_lb
  ]

  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.private_subnet_ids[count.index % var.private_subnet_ids.size]
  associate_public_ip_address = false 
  iam_instance_profile = var.iam_profile_name

  key_name               = var.aws_keypair_name
  vpc_security_group_ids = var.security_group_ids

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]

    command = <<-EOF
    set -Ee -o pipefail
    export AWS_DEFAULT_REGION=${var.aws_region}
    sleep 20

    ssh -i ${var.ssh_key_filename} -o StrictHostKeyChecking=no -o ProxyCommand='sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession"' ubuntu@${self.id} "cloud-init status --wait > /dev/null"

    if [ $? -eq 0 ]; then
      echo "Cloud-init detected to finish"
    else
      echo "Cloud-init detected to fail"
      exit 1
    fi

    EOF
  }


  root_block_device {
    volume_size = var.node_disk_size
  }

  user_data    = <<EOT
        #cloud-config
        package_update: true
        write_files:
        - path: /etc/rancher/rke2/config.yaml
          owner: root
          content: |
            token: ${var.cluster_token}
            server: https://${data.aws_lb.apiserver_lb.dns_name}:9345
        packages:
        - qemu-guest-agent
        runcmd:
        - - systemctl
          - enable
          - '--now'
          - qemu-guest-agent.service
        - curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" INSTALL_RKE2_VERSION=${var.rke2_version} sh -
        - systemctl enable rke2-agent.service
        - systemctl start rke2-agent.service
        ssh_authorized_keys: 
        - ${var.ssh_public_key}
      EOT

  tags = "${merge(var.tags, {Name = "${var.name_prefix}-${count.index + 1}"})}"
}