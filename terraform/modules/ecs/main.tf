resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/threat-app"
  retention_in_days = 3

  tags = {
    Name    = "ecs-log-group"
    Project = "ecs"
  }
}

resource "aws_ecs_cluster" "this" {
  name = "threat-app-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name    = "threat-app-cluster"
    Project = "ecs"
  }
}

data "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"
}

data "aws_ecr_image" "app" {
  repository_name = var.ecs_ecr_repo_name
  most_recent     = true
}

resource "aws_ecs_task_definition" "app" {
  family                   = "threat-app-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "threat-app"
      image     = "${split("@", data.aws_ecr_image.app.image_uri)[0]}:latest"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name    = "threat-app-td"
    Project = "ecs"
  }
}

resource "aws_ecs_service" "app" {
  name            = "threat-app-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.private_subnet_2a_id, var.private_subnet_2b_id]
    security_groups  = [var.ecs_service_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "threat-app"
    container_port   = 8080
  }

  tags = {
    Name    = "threat-app-service"
    Project = "ecs"
  }
}

resource "aws_cloudwatch_dashboard" "app" {
  dashboard_name = "threat-app-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.this.name, "ServiceName", aws_ecs_service.app.name],
            ["AWS/ECS", "MemoryUtilization", "ClusterName", aws_ecs_cluster.this.name, "ServiceName", aws_ecs_service.app.name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "ECS CPU and Memory"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_arn_suffix],
            ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", "LoadBalancer", var.alb_arn_suffix],
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", var.alb_arn_suffix]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "ALB Request Metrics"
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 6
        width  = 24
        height = 6
        properties = {
          query   = "SOURCE '${aws_cloudwatch_log_group.app.name}' | fields @timestamp, @message | sort @timestamp desc | limit 50"
          region  = var.aws_region
          title   = "Application Logs"
          view    = "table"
        }
      }
    ]
  })
}
