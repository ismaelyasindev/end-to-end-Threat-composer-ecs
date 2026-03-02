module "vpc" {
  source     = "./modules/vpc"
  aws_region = var.aws_region
}

module "sg" {
  source         = "./modules/sg"
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
  ecs_task_port  = var.ecs_task_port
}

data "aws_acm_certificate" "this" {
  count    = var.ecs_domain != "" && var.ecs_route53_domain != "" ? 1 : 0
  domain   = var.ecs_domain
  statuses = ["ISSUED"]
}

module "alb" {
  source            = "./modules/alb"
  alb_sg_id         = module.sg.alb_sg_id
  alb_subnet_public = [module.vpc.public_subnet_2a_id, module.vpc.public_subnet_2b_id]
  vpc_id            = module.vpc.vpc_id
  ecs_task_port     = var.ecs_task_port
  certificate_arn   = var.ecs_domain != "" && var.ecs_route53_domain != "" ? data.aws_acm_certificate.this[0].arn : ""
}

module "acm" {
  source = "./modules/acm"
  count  = var.ecs_domain != "" && var.ecs_route53_domain != "" ? 1 : 0

  ecs_domain         = var.ecs_domain
  ecs_route53_domain = var.ecs_route53_domain
  alb_dns_name       = module.alb.alb_dns_name
  alb_zone_id        = module.alb.alb_zone_id
}

module "ecs" {
  source               = "./modules/ecs"
  ecs_ecr_repo_name    = var.ecs_ecr_repo_name
  target_group_arn     = module.alb.target_group_arn
  ecs_service_sg_id    = module.sg.ecs_service_sg_id
  private_subnet_2a_id = module.vpc.private_subnet_2a_id
  private_subnet_2b_id = module.vpc.private_subnet_2b_id
  alb_arn_suffix       = module.alb.alb_arn_suffix
  aws_region           = var.aws_region
}
