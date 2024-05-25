output "ip" {
  value = aws_instance.Devi.public_ip
  sensitive = true
}

output "private_ip" {
  value = aws_instance.Devi.private_ip
  sensitive = false
}