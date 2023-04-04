#https://docs.aws.amazon.com/autoscaling/application/APIReference/API_RegisterScalableTarget.html
resource "aws_appautoscaling_target" "this" {
  count = var.autoscaling.enabled ? 1 : 0

  max_capacity       = var.autoscaling.max_capacity
  min_capacity       = var.autoscaling.min_capacity
  resource_id        = "service/${var.cluster.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "memory" {
  count = var.autoscaling.enabled ? 1 : 0

  name        = "${aws_ecs_service.this.name}-memory-autoscaling"
  policy_type = "TargetTrackingScaling"

  resource_id        = aws_appautoscaling_target.this[0].resource_id
  scalable_dimension = aws_appautoscaling_target.this[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = var.autoscaling.memory_average_utilization
    scale_in_cooldown  = var.autoscaling.scale_in_cooldown
    scale_out_cooldown = var.autoscaling.scale_out_cooldown
  }
}

resource "aws_appautoscaling_policy" "cpu" {
  count = var.autoscaling.enabled ? 1 : 0

  name        = "${aws_ecs_service.this.name}-cpu-autoscaling"
  policy_type = "TargetTrackingScaling"

  resource_id        = aws_appautoscaling_target.this[0].resource_id
  scalable_dimension = aws_appautoscaling_target.this[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.autoscaling.cpu_average_utilization
    scale_in_cooldown  = var.autoscaling.scale_in_cooldown
    scale_out_cooldown = var.autoscaling.scale_out_cooldown
  }
}
