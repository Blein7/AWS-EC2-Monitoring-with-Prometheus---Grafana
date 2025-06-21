variable "region" {
  default = "us-east-1"
}

variable "node_count" {
  description = "Number of EC2 nodes to monitor"
  type        = number
  default     = 3
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where to deploy"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where to deploy"
  type        = string
}