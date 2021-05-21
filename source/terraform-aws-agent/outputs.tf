output "build_server_ip" {
  value = aws_instance.build.public_ip
}

output "prod_server_ip" {
  value = aws_instance.prod.public_ip
}

