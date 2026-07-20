variable "s3_bucket_name" {
  description = "Globally unique name for the Terraform state bucket"
  type        = string
}

variable "aws_region" {
  description = "AWS region used for the backend bucket"
  type        = string
  default     = "eu-west-2"
}

variable "tags" {
  description = "Tags applied to the backend resources"
  type        = map(string)
  default     = {}
}
