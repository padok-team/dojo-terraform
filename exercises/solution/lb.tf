resource "aws_lb_target_group" "this" {
  for_each = local.applications

  name        = "${local.github_handle}-${each.key}" #TOFILL
  port        = each.value.port                      #TOFILL
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = local.vpc_id #TOFILL

  health_check {
    enabled             = true
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener_rule" "this" {
  for_each = local.applications

  listener_arn = "arn:aws:elasticloadbalancing:eu-west-3:450568479740:listener/app/padok-dojo-lb/5eabd2f998bc4441/e186af839a08466f"
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }
  condition {
    host_header {
      values = ["${local.github_handle}-${each.key}.${local.zone_name}"] #TOFILL
    }
  }

  lifecycle {
    ignore_changes = [
      priority
    ]
  }
}
