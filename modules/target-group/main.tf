resource "aws_lb_target_group" "tg" {
  name     = var.name
  port     = var.port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener_rule" "host_based_weighted_routing" {
  listener_arn = var.listener_arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    host_header {
      values = var.host_headers
    }
  }
}