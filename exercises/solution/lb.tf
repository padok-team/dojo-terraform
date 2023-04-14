resource "aws_lb_target_group" "this" {
  name        = "<github-handle>-<app>" #TOFILL
  port        = ""                      #TOFILL USING MAP (application -> port)
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "" #TOFILL (harcoded)

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
  listener_arn = "" #TOFILL (harcoded)
  action {
    type             = "forward"
    target_group_arn = "" #TOFILL USING LB TARGET GROUP OUTPUT
  }
  condition {
    host_header {
      values = [local.endpoint] #TOFILL USING MAP (application -> endpoint)
    }
  }

  lifecycle {
    ignore_changes = [
      priority
    ]
  }
}
