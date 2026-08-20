variable "bucket_name" {
  description = "Name of the S3 bucket used for ALB access logs"
  type        = string
}

variable "tags" {
  description = "Tags applied to the S3 bucket"
  type        = map(string)
  default     = {}
}