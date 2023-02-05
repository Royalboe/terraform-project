# Create a Route53 Zone
resource "aws_route53_zone" "my_zone" {
  name = "royalboe.com"
  vpc {
    vpc_id = aws_vpc.Altschool_Net.id
  }
}

# Create a Route53 Record
resource "aws_route53_record" "terraform-test" {
  zone_id = aws_route53_zone.my_zone.zone_id
  name    = "terraform-test.royalboe.com"
  type    = "A"
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = false
  }
}