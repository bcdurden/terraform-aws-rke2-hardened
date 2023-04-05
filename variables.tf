variable "environment_name" {
  type        = string
  description = "The name of this environment"
}

variable "vpc_id" {
  type        = string
  description = "Target VPC"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The list of public Subnet IDs within the environment"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "The list of private Subnet IDs within the environment"
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

variable "control_plane_ha_mode" {
    type        = bool
    description = "The boolean trigger for installing an HA control plane (ie. 3 nodes)"
    default     = false
}

variable "cp_name_prefix" {
    type    = string
    default = "rke2-mgmt-controlplane"
}

variable "worker_name_prefix" {
    type    = string
    default = "rke2-mgmt-worker"
}

variable "kubeconfig_filename" {
    type    = string
    default = "kube_config_server.yaml"
}

variable "rke2_server_dns" {
  type        = string
  description = "Optional DNS host for RKE2 API Server LB"
  default     = "empty.lol"
}

variable "worker_count" {
  type        = string
  description = "The number of worker nodes to create"
  default     = 3
}

variable "node_disk_size_gb" {
  type        = string
  default     = 20
  description = "The size of the hard drive on each node in GB"
}

variable "cluster_token" {
    type        = string
    description = "The join token for the cluster"
}

variable "rke2_version" {
  type        = string
  default     = "v1.24.9+rke2r2"
  description = "The string defining the RKE2 version desired"
}

variable "rke2_registry" {
  type = string
  default = ""
  description = "Default system registry (Carbide registry goes here)"
}

variable "carbide_username" {
  type        = string
  default     = ""
  description = "Your Issued Carbide Registry ID goes here"
}

variable "carbide_password" {
  type        = string
  default     = ""
  description = "Your Issued Carbide Registry Secret goes here"
}

variable "tags" {
  type = map
  default = {}
  description = "Tags to apply to all AWS resources"
}

locals {
  default_tags = {
    Environment = "${var.environment_name}"
    Creator = "Terraform"
  }

  actual_tags = "${merge(var.tags, local.default_tags)}"
}