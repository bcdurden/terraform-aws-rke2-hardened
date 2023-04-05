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
  description = "List of subnet IDs for node(s)."
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

variable "aws_keypair_name" {
    type        = string
    description = "The AWS keypair to attach to the EC2 instance(s)"
}

variable "ami_id" {
  type        = string
  description = "AMI to be used for each EC2 instance"
}

variable "iam_profile_name" {
    type        = string
    description = "The IAM profile to attach to the EC2 instance(s)"
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

variable "cp_main_ip" {
  type = string
  description = "The IP of the control plane node"
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

variable "worker_count" {
    type        = number
    description = "The amount of worker nodes to create"  
    default     = 3
}

variable "tags" {
  type        = map
  default     = {}
  description = "Tags to apply to all AWS resources"  
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