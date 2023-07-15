# --- networking/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.my_rds_subnet_group.*.name
}

output "vpc_private_security_group_ids" {
  value = [aws_security_group.my_sgs["rds"].id]
}

output "vpc_public_security_group_ids" {
  value = [aws_security_group.my_sgs["public"].id]
}

output "lb_public_subnets" {
  value = aws_subnet.my_public_subnets.*.id
}