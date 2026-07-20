variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for the public subnets"
  type        = list(string)
}

variable "target_group_port" {
  description = "Port the ECS application listens on"
  type        = number
  default     = 3000
}

variable "ecs_task_cpu" {
  type = string
}

variable "ecs_task_memory" {
  type = string
}

variable "ecs_service_desired_count" {
  type = number
}

variable "ecr_image_tag" {
  type = string
}

variable "log_stream_prefix" {
  type    = string
  default = "ecs"
}

variable "log_retention_in_days" {
  type    = number
  default = 14
}

variable "github_repository" {
  description = "GitHub repository in owner/repository format"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch allowed to deploy"
  type        = string
  default     = "main"
}

variable "terraform_state_bucket_arn" {
  description = "ARN of the Terraform state bucket"
  type        = string
}