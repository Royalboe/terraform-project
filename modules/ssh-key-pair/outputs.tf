output "key_name" {
  description = "Name of the key pair"
  value       = aws_key_pair.devkey.key_name
}