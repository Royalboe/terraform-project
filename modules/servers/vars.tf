variable "pub_subnet_1" {}
variable "pub_subnet_2" {}
variable "pub_subnet_3" {}
variable "web_server_SG" {}
variable "key_name" {}
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