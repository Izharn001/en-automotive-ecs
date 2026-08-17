resource "aws_route53_zone" "main" {
    name = var.domain_name

    tags = {
        Name = var.domain_name
    }
}

resource "aws_route53_record" "ecs" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.subdomain
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}