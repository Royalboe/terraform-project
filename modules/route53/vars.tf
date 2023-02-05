varible "domain" {
  description = "Domain name to create"
  type        = string
  default     = "example.com"
}
variable "vpc_id" {
  description = "VPC ID to create the Route53 Zone in"
  type        = string
}
variable "lb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}
variable "alb_zone_id" {
  description = "Zone ID of the ALB"
  type        = string
}
variable "proj-tag" {
  description = "Tags to apply to resources created by this module"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev-test"
  }
}
