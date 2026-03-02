variable "ecs_ecr_repo_name" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ecs_service_sg_id" {
  type = string
}

variable "private_subnet_2a_id" {
  type = string
}

variable "private_subnet_2b_id" {
  type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "eu-west-2"
}
