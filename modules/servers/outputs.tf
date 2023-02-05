output "web_ids" {
  value = [aws_instance.web_1.id, aws_instance.web_2.id, aws_instance.web_3.id]
}