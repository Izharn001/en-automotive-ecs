output "bucket_id" {
  description = "ID of the ALB access logs bucket"
  value       = aws_s3_bucket.alb_logs.id
}

output "bucket_arn" {
  description = "ARN of the ALB access logs bucket"
  value       = aws_s3_bucket.alb_logs.arn
}