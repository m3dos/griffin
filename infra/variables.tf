variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-2"
}

variable "subnet_ids" {
  description = "List of existing subnet IDs to deploy the ECS tasks in"
  type        = list(string)
  default     = ["subnet-08bc78cd85cdc39bf", "subnet-0912e43508238d9a8", "subnet-0bb007dd927d2fcda"]  # Update with your subnet IDs
}

variable "security_group_ids" {
  description = "List of existing security group IDs for the ECS tasks"
  type        = list(string)
  # Update the default values or override them in terraform.tfvars
  default     = ["sg-0b65bc6a2e7ca5bb0"]
}

