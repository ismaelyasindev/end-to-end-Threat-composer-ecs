variable "alb_sg_id" {
  type = string
}

variable "alb_subnet_public" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "ecs_task_port" {
  type    = number
  default = 8080
}

variable "alb_ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "certificate_arn" {
  type    = string
  default = ""
}
