variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "ecs_task_port" {
  type    = number
  default = 8080
}
