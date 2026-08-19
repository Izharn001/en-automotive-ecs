variable "iam_role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}


variable "terraform_state_bucket_arn" {
  type = string
}