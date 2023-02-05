output "fqdn" {
  description = "The FQDN of the record"
  value       = aws_route53_record.terraform-test.fqdn
}
output "record_name" {
  description = "ID of the public subnet"
  value       = aws_route53_record.terraform-test.name
}
