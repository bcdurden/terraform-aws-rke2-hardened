# Security group to allow all traffic
resource "aws_security_group" "rancher_sg_allowall" {
  name        = "${var.prefix}-rancher-allowall"
  description = "Rancher AWS Terraform - allow all traffic"
  vpc_id = var.vpc_id

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${local.actual_tags}"
}
resource "aws_security_group" "rancher_sg_443" {
  name        = "${var.prefix}-rancher-443"
  description = "Rancher AWS Terraform - allow https traffic"
  vpc_id = var.vpc_id

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "https"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "https"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${local.actual_tags}"
}
resource "aws_security_group" "rancher_sg_6443" {
  name        = "${var.prefix}-rancher-443"
  description = "Rancher AWS Terraform - allow https traffic"
  vpc_id = var.vpc_id

  ingress {
    from_port   = "6443"
    to_port     = "6443"
    protocol    = "https"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "https"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${local.actual_tags}"
}
resource "aws_security_group" "rancher_sg_9345" {
  name        = "${var.prefix}-rancher-9345"
  description = "Rancher AWS Terraform - allow cluster-join traffic"
  vpc_id = var.vpc_id

  ingress {
    from_port   = "9345"
    to_port     = "9345"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${local.actual_tags}"
}