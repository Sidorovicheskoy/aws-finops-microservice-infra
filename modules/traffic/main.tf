# --- Security Group for Load Balancer ---
resource "aws_security_group" "alb" {
  name        = "${var.namespace}-${var.stage}-alb-sg"
  description = "Controls access to the Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP inbound from Internet"
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

# --- Security Group for ECS (Chained) ---
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.namespace}-${var.stage}-ecs-tasks-sg"
  description = "Allow inbound access only from the ALB"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.container_port
    to_port         = var.container_port
    security_groups = [aws_security_group.alb.id] # Strict Security Chaining
    description     = "Ingress from ALB only"
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

# --- Application Load Balancer ---
resource "aws_lb" "main" {
  name               = "${var.namespace}-${var.stage}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnets
  tags               = var.tags
}

resource "aws_lb_target_group" "app" {
  name        = "${var.namespace}-${var.stage}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" # Crucial for Fargate

  health_check {
    path                = "/healthz" # Changed from /health to look more custom
    healthy_threshold   = 3
    interval            = 60
    matcher             = "200-299"
  }
  tags = var.tags
}
# ... (Listeners) ...