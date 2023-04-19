
resource "aws_ecs_service" "this" {
  name                 = var.config.name
  cluster              = var.cluster.id
  task_definition      = aws_ecs_task_definition.this.arn
  launch_type          = "FARGATE"
  desired_count        = var.config.desired_count
  force_new_deployment = true

  network_configuration {
    subnets          = var.private_subnets_ids
    assign_public_ip = false
    security_groups = [
      aws_security_group.service.id
    ]
  }

  dynamic "load_balancer" {
    for_each = var.lb.enabled ? [1] : []
    content {
      target_group_arn = var.lb.target_group_arn
      container_name   = var.config.name
      container_port   = var.config.port
    }
  }

  lifecycle {
    ignore_changes = [
      capacity_provider_strategy
    ]
  }
}

resource "aws_security_group" "service" {
  name   = "${var.cluster.name}-${var.config.name}"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.lb.enabled ? [1] : []
    content {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      security_groups = [var.lb.security_group_id]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
