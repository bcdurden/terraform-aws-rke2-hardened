# AWS infrastructure resources
resource "aws_instance" "rancher_server_main" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_ids[0] # use the first by default
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
    volume_size = var.node_disk_size_gb
  }

  user_data    = <<EOT
        #cloud-config
        package_update: true
        write_files:
        - path: /etc/rancher/rke2/config.yaml
          owner: root
          content: |
            token: ${var.cluster_token}
            tls-san:
            - ${var.rke2_server_dns}
            - ${var.lb_dns_name}
            system-default-registry: ${var.rke2_registry}
            profile: cis-1.6
            selinux: true
            secrets-encryption: true
            write-kubeconfig-mode: 0640
            use-service-account-credentials: true
            kube-controller-manager-arg:
            - bind-address=127.0.0.1
            - use-service-account-credentials=true
            - tls-min-version=VersionTLS12
            - tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
            kube-scheduler-arg:
            - tls-min-version=VersionTLS12
            - tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
            kube-apiserver-arg:
            - tls-min-version=VersionTLS12
            - tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
            - authorization-mode=RBAC,Node
            - anonymous-auth=false
            - audit-policy-file=/etc/rancher/rke2/audit-policy.yaml
            - audit-log-mode=blocking-strict
            - audit-log-maxage=30
            kubelet-arg:
            - protect-kernel-defaults=true
            - read-only-port=0
            - authorization-mode=Webhook
            - streaming-connection-idle-timeout=5m
        - path: /etc/rancher/rke2/registries.yaml
          owner: root
          content: |
            configs:
              "rgcrprod.azurecr.us":
                auth:
                  username: ${var.carbide_username}
                  password: ${var.carbide_password}
        runcmd:
        - curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=${var.rke2_version} sh -
        - systemctl enable rke2-server.service
        - cp -f /usr/local/share/rke2/rke2-cis-sysctl.conf /etc/sysctl.d/60-rke2-cis.conf
        - useradd -r -c "etcd user" -s /sbin/nologin -M etcd -U
        - systemctl restart systemd-sysctl
        - systemctl start rke2-server.service
        ssh_authorized_keys: 
        - ${var.ssh_public_key}
      EOT

  tags = "${merge(var.tags, {Name = "${var.name_prefix}-0"})}"
}

resource "aws_instance" "rancher_server_ha" {
  count = var.ha_mode ? 2 : 0
  depends_on = [
    aws_instance.rancher_server_main
  ]
  
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_ids[(count.index + 1) % length(var.subnet_ids)]
  associate_public_ip_address = false 
  iam_instance_profile = var.iam_profile_name

  key_name               = var.aws_keypair_name
  vpc_security_group_ids = var.security_group_ids

  root_block_device {
    volume_size = var.node_disk_size_gb
  }

  user_data    = <<EOT
        #cloud-config
        package_update: true
        write_files:
        - path: /etc/rancher/rke2/config.yaml
          owner: root
          content: |
            token: ${var.cluster_token}
            server: https://${aws_instance.rancher_server_main.private_ip}:9345
            tls-san:
            - ${var.rke2_server_dns}
            - ${var.lb_dns_name}
            profile: cis-1.6
            selinux: true
            secrets-encryption: true
            write-kubeconfig-mode: 0640
            use-service-account-credentials: true
            kube-controller-manager-arg:
            - bind-address=127.0.0.1
            - use-service-account-credentials=true
            - tls-min-version=VersionTLS12
            - tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
            kube-scheduler-arg:
            - tls-min-version=VersionTLS12
            - tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
            kube-apiserver-arg:
            - tls-min-version=VersionTLS12
            - tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
            - authorization-mode=RBAC,Node
            - anonymous-auth=false
            - audit-policy-file=/etc/rancher/rke2/audit-policy.yaml
            - audit-log-mode=blocking-strict
            - audit-log-maxage=30
            kubelet-arg:
            - protect-kernel-defaults=true
            - read-only-port=0
            - authorization-mode=Webhook
            - streaming-connection-idle-timeout=5m
        runcmd:
        - curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=${var.rke2_version} sh -
        - systemctl enable rke2-server.service
        - cp -f /usr/local/share/rke2/rke2-cis-sysctl.conf /etc/sysctl.d/60-rke2-cis.conf
        - useradd -r -c "etcd user" -s /sbin/nologin -M etcd -U
        - systemctl restart systemd-sysctl
        - systemctl start rke2-server.service
        ssh_authorized_keys: 
        - ${var.ssh_public_key}
      EOT

  tags = "${merge(var.tags, {Name = "${var.name_prefix}-${count.index + 1}"})}"
}
