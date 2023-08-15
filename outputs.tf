output "public_ip" {
  value = aws_instance.ec2["public-instance"].public_ip
}

output "private_ip" {
  value = aws_instance.ec2["private-instance"].private_ip
}
