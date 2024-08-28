variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "ami" {
  description = "The AMI ID to use for the GitLab server."
  type        = string
  default     = "ami-066784287e358dad1"  # Amazon Linux 2023 AMI for us-east-1
}

variable "instance_type" {
  description = "The instance type to use for the GitLab server."
  type        = string
  default     = "t2.medium" 
}

variable "key_name" {
  description = "The name of the SSH key pair to use for the instance."
  type        = string
  default     = "your_key_name"
}
