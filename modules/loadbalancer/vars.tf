variable "lb_name" {}
variable "lb_sec_grps" {
    type = list(string)
}
variable "public_subnets" {
    type = list(string)
}
variable "vpc_id" {}
variable "namespace" {
    type = string
    description = "(optional) describe your variable"
    default = "dev-test"
}
variable "proj-tag" {
  description = "Tags to apply to resources created by this module"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev-test"
  }
}
variable "web_ids"{
    type = list(any)
}