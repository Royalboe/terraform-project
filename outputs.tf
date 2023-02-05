output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.Altschool_Net.id
}

output "pub_subnet_1" {
  description = "ID of the public subnet"
  value       = aws_subnet.publicsubnet_1.id
}

output "pub_subnet_2" {
  description = "ID of the public subnet"
  value       = aws_subnet.publicsubnet_2.id
}

output "pub_subnet_3" {
  description = "ID of the public subnet"
  value       = aws_subnet.publicsubnet_3.id
}

output "web_1" {
  description = "ID of the web server"
  value       = aws_instance.web_1.public_ip
}

output "web_2" {
  description = "ID of the web server"
  value       = aws_instance.web_2.public_ip
}

output "web_3" {
  description = "ID of the web server"
  value       = aws_instance.web_3.public_ip
}