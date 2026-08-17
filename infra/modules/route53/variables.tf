variable "domain_name" {
  description = "The domain name for the Route 53 hosted zone"
  type        = string
}

variable "subdomain" {
  description = "Subdomain pointing to the ALB"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "Hosted zone ID of the ALB"
  type        = string
}