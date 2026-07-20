module "ecr" {
  source = "./modules/ecr"

  repository_name = "${var.project_name}-app"
  tags            = local.common_tags
}

module "network" {
  source = "./modules/network"

  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
  tags                = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  alb_name            = "${var.project_name}-alb"
  target_group_name   = "${var.project_name}-target-group"
  target_group_port   = var.target_group_port
  security_group_name = "${var.project_name}-alb-sg"

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.public_subnet_ids

  tags = local.common_tags
}

module "iam" {
  source = "./modules/iam"

  iam_role_name              = "${var.project_name}-ecs-execution-role"
  github_repository          = var.github_repository
  github_branch              = var.github_branch
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

  subnet_ids            = module.network.public_subnet_ids
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

