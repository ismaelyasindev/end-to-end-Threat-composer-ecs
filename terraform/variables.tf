variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "ecs_task_port" {
  type    = number
  default = 8080
}

variable "ecs_ecr_repo_name" {
  type    = string
  default = "ismaelyasindev_end-to-end-threat-composer-ecs"
}

variable "ecs_domain" {
  type    = string
  default = "threat.ismaelawsdashboard.site"
}

variable "ecs_route53_domain" {
  type    = string
  default = "ismaelawsdashboard.site"
}
