variable "pub_subnets" {
    type = list(string)
}
variable "web_server_SG" {}
variable "key_name" {}
variable "namespace" {
  type        = string
}
variable "proj-tag" {
    type = map(string)
    default = {
      Terraform   = "true"
      Environment = "dev-test"
  }
}
variable "availability_zones" {
    type = list(string)
}