variable "iam_role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "github_repository" {
  description = "GitHub repository in owner/repository format"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch allowed to assume the deployment role"
  type        = string
  default     = "main"
}

variable "terraform_state_bucket_arn" {
  type = string
}