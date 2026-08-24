variable "project_name" {
  description = "Project name used for CloudWatch alarm names"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "ARN suffix of the ALB target group"
  type        = string
}

variable "load_balancer_arn_suffix" {
  description = "ARN suffix of the Application Load Balancer"
  type        = string
}

variable "tags" {
  description = "Tags applied to monitoring resources"
  type        = map(string)
  default     = {}
}

variable "alert_email" {
  description = "Email address that receives infrastructure alerts"
  type        = string
}