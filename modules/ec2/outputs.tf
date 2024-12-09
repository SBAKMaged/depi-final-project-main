output "ec2_public_ip_az1" {
  value = aws_instance.public_ec2_az1.public_ip
}

output "ec2_public_ip_az2" {
  value = aws_instance.public_ec2_az2.public_ip
}
output "ec2_private_ip_az1" {
  value = aws_instance.private_ec2_az1.private_ip
}

output "ec2_private_ip_az2" {
  value = aws_instance.private_ec2_az2.private_ip
}

output "private_key_pem" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
}