variable "region" {}
variable "availability_zones" {
    type = list(string)
}
variable "main_vpc_cidr" {}
variable "public_subnet_1" {}
variable "public_subnet_2" {}
variable "public_subnet_3" {}
variable "destination_cidr_block" {}