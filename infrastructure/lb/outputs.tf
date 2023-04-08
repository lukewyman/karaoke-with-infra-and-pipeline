output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}

output "lb_listener_arn" {
  value = aws_lb_listener.listener.arn
}