# Create a Route53 Zone
resource "aws_route53_zone" "my_zone" {
  name = var.domain
  vpc {
    vpc_id = var.vpc_id
  }
  tags = var.proj-tag
}

# Create a Route53 Record
resource "aws_route53_record" "terraform-test" {
  zone_id = aws_route53_zone.my_zone.zone_id
  name    = "terraform-test.royalboe.com"
  type    = "A"
  alias {
    name                   = var.lb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}