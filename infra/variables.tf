variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "en-automotive"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for the public subnets"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "target_group_port" {
  description = "Port the ECS application listens on"
  type        = number
  default     = 3000
}

variable "ecs_task_cpu" {
  type    = string
  default = "256"
}

variable "ecs_task_memory" {
  type    = string
  default = "512"
}

variable "ecs_service_desired_count" {
  type    = number
  default = 1
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
  default     = "Izharn001/en-automotive-ecs"
}

variable "github_branch" {
  description = "GitHub branch allowed to deploy"
  type        = string
  default     = "main"
}

variable "terraform_state_bucket_arn" {
  description = "ARN of the Terraform state bucket"
  type        = string
  default     = "arn:aws:s3:::en-automotive-terraform-state"
}