# Create a Route53 Zone
resource "aws_route53_zone" "my_zone" {
  name = var.domain
  tags = var.proj-tag
}

# Create a Route53 Record
resource "aws_route53_record" "terraform-test" {
  zone_id = aws_route53_zone.my_zone.zone_id
  name    = "terraform-test.${var.domain}"
  type    = "A"
  alias {
    name                   = var.lb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
