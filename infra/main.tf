module "ecr" {
  source = "./modules/ecr"

  repository_name = "${var.project_name}-app"
  tags            = local.common_tags
}

module "network" {
  source = "./modules/network"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  tags                 = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  alb_name            = "${var.project_name}-alb"
  target_group_name   = "${var.project_name}-target-group"
  target_group_port   = var.target_group_port
  security_group_name = "${var.project_name}-alb-sg"

  certificate_arn = module.acm.certificate_arn
  vpc_id          = module.network.vpc_id
  subnet_ids      = module.network.public_subnet_ids
  alb_logs_bucket = module.s3.bucket_id

  tags = local.common_tags
}

module "iam" {
  source = "./modules/iam"

  iam_role_name              = "${var.project_name}-ecs-execution-role"
  terraform_state_bucket_arn = var.terraform_state_bucket_arn

  tags = local.common_tags
}

module "ecs" {
  source = "./modules/ecs"

  ecs_cluster_name          = "${var.project_name}-ecs-cluster"
  ecs_service_name          = "${var.project_name}-ecs-service"
  ecs_container_name        = "${var.project_name}-ecs-container"
  ecs_task_family           = "${var.project_name}-ecs-task"
  ecs_task_cpu              = var.ecs_task_cpu
  ecs_task_memory           = var.ecs_task_memory
  container_port            = var.target_group_port
  ecs_service_desired_count = var.ecs_service_desired_count

  subnet_ids            = module.network.private_subnet_ids
  vpc_id                = module.network.vpc_id
  alb_security_group_id = module.alb.alb_security_group_id
  execution_role_arn    = module.iam.execution_role_arn
  ecr_repository_url    = module.ecr.repository_url
  ecr_image_tag         = var.ecr_image_tag
  security_group_name   = "${var.project_name}-ecs-sg"
  target_group_arn      = module.alb.target_group_arn

  aws_region            = var.aws_region
  log_stream_prefix     = var.log_stream_prefix
  log_retention_in_days = var.log_retention_in_days

  tags = local.common_tags
}

module "route53" {
  source = "./modules/route53"

  domain_name = "enautomotive.co.uk"
  subdomain   = "ecs.enautomotive.co.uk"

  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id

}



module "acm" {
  source = "./modules/acm"

  domain_name = "ecs.enautomotive.co.uk"
  zone_id     = module.route53.zone_id
}


module "s3" {
  source = "./modules/s3"

  bucket_name = "en-automotive-alb-logs-707305182979"

  tags = local.common_tags
}