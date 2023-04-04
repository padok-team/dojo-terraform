output "this" {
  description = "The ECS cluster instance."
  value = {
    name = aws_ecs_cluster.this.name
    id   = aws_ecs_cluster.this.id
  }
}

output "lb" {
  description = "The load balancer instance configuration."
  value = {
    listener_arn      = aws_lb_listener.https.arn
    dns_name          = aws_alb.this.dns_name
    security_group_id = aws_security_group.cluster_lb.id
  }
}
