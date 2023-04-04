variable "vpc_id" {
  type        = string
  description = "Target VPC"
}

variable "subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key used to create infrastructure"
}
 
variable "aws_secret_key" {
  type        = string
  description = "AWS secret key used to create AWS infrastructure"
}

variable "aws_session_token" {
  type        = string
  description = "AWS session token used to create AWS infrastructure"
  default     = ""
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
  default     = "us-gov-west-1"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "multicloud-demo"
}

variable "control_plane_instance_type" {
  type        = string
  description = "Instance type used for controlplane EC2 instances"
  default     = "t3a.medium"
}
variable "worker_instance_type" {
  type        = string
  description = "Instance type used for worker EC2 instances"
  default     = "t3a.medium"
}

variable "ami_id" {
  type        = string
  default     = "ami-0f1289f37e46c1eff"
}

variable "cp_name_prefix" {
    type = string
    default = "rke2-mgmt-controlplane"
}
variable "worker_name_prefix" {
    type = string
    default = "rke2-mgmt-worker"
}
variable "kubeconfig_filename" {
    type = string
    default = "kube_config_server.yaml"
}

variable "rke2_server_dns" {
  type        = string
  description = "Optional DNS host for RKE2 API Server LB"
  default     = "empty.lol"
}

variable "worker_count" {
  type = string
  default = 3
}
variable "node_disk_size_gb" {
  type = string
  default = 20
}
variable "cluster_token" {
    type = string
    default = "my-shared-token"
}
variable "rke2_version" {
  type = string
  default = "v1.24.9+rke2r2"
}

variable "tags" {
  type = map
  default = {Owner = "brian"}
  description = "Tags to apply to all AWS resources"
}

locals {
  default_tags = {
    Environment = "${var.environment_name}"
    Creator = "Terraform"
  }

  actual_tags = "${merge(var.tags, local.default_tags)}"
}