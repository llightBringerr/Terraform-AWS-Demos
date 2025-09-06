output "public_ip_address" {
  description = "The public IP address of the instance"
  value       = aws_instance.demo1.public_ip
  
}