variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_task_cpu" {
  description = "CPU units for the ECS task"
  type        = string
}

variable "ecs_task_memory" {
  description = "Memory for the ECS task"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
}

variable "ecs_container_name" {
  description = "Name of the ECS container"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "ecs_service_desired_count" {
  description = "Desired number of ECS service tasks"
  type        = number
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ECS service"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the ECS service"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the IAM role for ECS task execution"
  type        = string
}

variable "ecr_repository_url" {
  description = "URL of the ECR repository"
  type        = string
}

variable "ecr_image_tag" {
  description = "Tag of the ECR image"
  type        = string
}

variable "security_group_name" {
  description = "Name of the security group for ECS tasks"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "target_group_arn" {
  description = "ARN of the target group for the ECS service"
  type        = string
}

variable "ecs_task_family" {
  description = "Family name for the ECS task definition"
  type        = string
}

variable "aws_region" {
  type = string
}

variable "log_stream_prefix" {
  type = string
}

variable "log_retention_in_days" {
  type = number
}