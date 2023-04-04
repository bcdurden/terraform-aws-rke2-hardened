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

variable "vpc_id" {
  type        = string
  description = "Target VPC for node(s)"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for node(s). Note for HA mode you will need 3 subnets"
}

variable "ha_mode" {
    type = bool
    description = "The boolean trigger for installing an HA control plane (ie. 3 nodes)"
    default = false
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all nodes"
}

variable "name_prefix" {
  type        = string
  description = "Name prefix added to names of all nodes"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for EC2 instances"
  default     = "t3a.medium"
}

variable "ami_id" {
  type        = string
  description = "AMI to be used for each EC2 instance"
}

variable "iam_profile_name" {
    type        = string
    description = "The IAM profile to attach to the EC2 instance(s)"
}

variable "aws_keypair_name" {
    type        = string
    description = "The AWS keypair to attach to the EC2 instance(s)"
}

variable "security_group_ids" {
    type        = list(string)
    description = "The Security Group IDs to attach to the EC2 instance(s)"
}

variable "node_disk_size_gb" {
  type        = string
  default     = 20
  description = "The EC2 node disk size in GB"
}

variable "cluster_token" {
    type = string
    default = "my-shared-token"
}

variable "rke2_server_dns" {
  type        = string
  description = "Optional DNS for RKE2 apiserver LB"
  default     = "empty.local"
}

variable "apiserver_lb_name" {
    type        = string
    description = "The ApiServer Load Balancer name"
}

variable "rke2_version" {
  type        = string
  default     = "v1.24.9+rke2r2"
  description = "The string defining the RKE2 version desired"
}

variable "ssh_public_key" {
    type        = string
    description = "The SSH public key to inject into the EC2 instance(s)"
}

variable "ssh_key_filename" {
    type        = string
    description = "The filename of the SSH private key"
}

variable "tags" {
  type        = map
  default     = {}
  description = "Tags to apply to all AWS resources"  
}