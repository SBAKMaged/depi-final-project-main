output "alb_target_groub_arn" {
  value = aws_lb_target_group.elb_target_groub.arn
}

output "app_load_balancer_dns_name" {
  value = aws_lb.elastic_load_balancer.dns_name
}
output "app_load_balancer_zone_id" {
  value = aws_lb.elastic_load_balancer.zone_id
}