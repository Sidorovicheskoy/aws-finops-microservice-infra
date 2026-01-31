resource "aws_ecs_cluster" "main" {
  name = "${var.namespace}-${var.stage}-cluster"
  
  setting {
    name  = "containerInsights"
    value = "enabled" # Professional Monitoring
  }
  tags = var.tags
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.namespace}-${var.stage}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  
  # Clean JSON generation via Terraform Function
  container_definitions = jsonencode([
    {
      name      = "${var.namespace}-${var.stage}-container"
      image     = var.container_image
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/aws/ecs/${var.namespace}-${var.stage}-app"
          "awslogs-region"        = "eu-central-1" # Pass as var in real scenario
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
  tags = var.tags
}

resource "aws_ecs_service" "main" {
  name                   = "${var.namespace}-${var.stage}-service"
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.app.arn
  desired_count          = 2
  launch_type            = "FARGATE"
  enable_execute_command = true # Allows debugging via SSM

  network_configuration {
    security_groups  = var.security_groups
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.namespace}-${var.stage}-container"
    container_port   = var.container_port
  }
  
  # Lifecycle rule to allow external Autoscaling
  lifecycle {
    ignore_changes = [desired_count]
  }
  tags = var.tags
}