output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "github_actions_role_arn" {
  value = module.iam.github_actions_role_arn
}

output "zone_id" {
  value = module.route53.zone_id
}

output "name_servers" {
  value = module.route53.name_servers
}