data "aws_region" "current" {}

resource "aws_cloudwatch_log_group" "this" {
  name = var.config.name
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.config.name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.config.cpu
  memory                   = var.config.memory

  execution_role_arn = aws_iam_role.this.arn
  task_role_arn      = aws_iam_role.this.arn

  # TODO: Add log configuration
  container_definitions = jsonencode([
    {
      name  = var.config.name,
      image = var.config.image,
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name,
          awslogs-region        = data.aws_region.current.name,
          awslogs-stream-prefix = var.config.name
        }
      },
      portMappings = [
        {
          containerPort = var.config.port,
          hostPort      = var.config.port
        }
      ],
      environment = [for k, v in var.config.environment : { name = k, value = v }],
      secrets     = [for k, v in var.config.secrets : { name = k, valueFrom = v }],

      networkMode = "awsvpc",
      essential   = true
    }
  ])
}
