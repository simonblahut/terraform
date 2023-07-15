# --- loadbalancing/outputs.tf ---

output "tg_arn" {
  value = aws_lb_target_group.my_tg.arn
}

output "lb_endpoint" {
  value = aws_lb.my_lb.dns_name
}