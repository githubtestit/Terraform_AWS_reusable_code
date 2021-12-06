output "app_eip" {
  value = aws_eip.cloud_addr.public_ip
}
 
output "app_instance" {
    value = aws_instance.cloud_web.id
}