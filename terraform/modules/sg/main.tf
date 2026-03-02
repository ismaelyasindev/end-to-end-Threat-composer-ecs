resource "aws_security_group" "alb" {
  name   = "ecs-alb-sg"
  vpc_id = var.vpc_id

  tags = {
    Name    = "ecs-alb-sg"
    Project = "ecs"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_task" {
  security_group_id            = aws_security_group.alb.id
  from_port                    = var.ecs_task_port
  to_port                      = var.ecs_task_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.task.id
}

resource "aws_security_group" "task" {
  name   = "ecs-task-sg"
  vpc_id = var.vpc_id

  tags = {
    Name    = "ecs-task-sg"
    Project = "ecs"
  }
}

resource "aws_vpc_security_group_ingress_rule" "task_from_alb" {
  security_group_id            = aws_security_group.task.id
  from_port                    = var.ecs_task_port
  to_port                      = var.ecs_task_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "task_https_out" {
  security_group_id = aws_security_group.task.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}
