# --- compute/outputs.tf ---

output "instance" {
  value     = aws_instance.my_node[*]
  sensitive = true
}

output "instance_port" {
  value = aws_lb_target_group_attachment.my_tg_attach[0].port
}