output "pub_security_group_id" {
  value = aws_security_group.public_sg.id
}

output "priv_security_group_id" {
  value = aws_security_group.private_sg.id
}
output "lb_security_group_id" {
  value = aws_security_group.lb_sg.id
}