output "lb_listener_arn" {
  value = aws_lb_listener.https.arn
}

output "lb_dns" {
  value = aws_lb.alb.dns_name
}
