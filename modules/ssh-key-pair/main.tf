# data "aws_availability_zones" "zones" {
#   state = "available"
# }

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create the VPC
 resource "aws_vpc" "Altschool_Net" {                # Creating VPC here
   cidr_block       = var.main_vpc_cidr     # Defining the CIDR block use 10.0.0.0/24
   instance_tenancy = "default"
   enable_dns_hostnames = true
 }

# Create Internet Gateway and attach it to VPC
 resource "aws_internet_gateway" "IGW" {    # Creating Internet Gateway
    vpc_id =  aws_vpc.Altschool_Net.id 
    tags = {
      Name = "Altschool"
      }        # CIDR block of public subnets              # vpc_id will be generated after we create VPC
 }

# Create an internet gateway
#  resource "aws_internet_gateway_attachment" "IGW_Attachment" {
#   internet_gateway_id = aws_internet_gateway.IGW.id
#   vpc_id              = aws_vpc.Altschool_Net.id
# } 

# Create a Public Subnets.
 resource "aws_subnet" "publicsubnet_1" {    # Creating Public Subnets
   vpc_id =  aws_vpc.Altschool_Net.id
   cidr_block = "${var.public_subnet_1}"        # CIDR block of public subnets
   map_public_ip_on_launch = true
  #  availability_zone       = data.aws_availability_zones.zones.names[0]
   availability_zone = var.availability_zones[0]
 }

  resource "aws_subnet" "publicsubnet_2" {    # Creating Public Subnets
    vpc_id =  aws_vpc.Altschool_Net.id
    cidr_block = "${var.public_subnet_2}"        # CIDR block of public subnets
    map_public_ip_on_launch = true
    # availability_zone       = data.aws_availability_zones.zones.names[1]
    availability_zone = var.availability_zones[1]
  }

  resource "aws_subnet" "publicsubnet_3" {    # Creating Public Subnets
    vpc_id =  aws_vpc.Altschool_Net.id
    cidr_block = "${var.public_subnet_3}"        # CIDR block of public subnets
    map_public_ip_on_launch = true
    # availability_zone       = data.aws_availability_zones.zones.names[2]
    availability_zone = var.availability_zones[2]
  }

# Route table for Public Subnet's
 resource "aws_route_table" "PublicRT" {    # Creating RT for Public Subnet
   vpc_id =  aws_vpc.Altschool_Net.id
   route {
     cidr_block = var.destination_cidr_block               # Traffic from Public Subnet reaches Internet via Internet Gateway
     gateway_id = aws_internet_gateway.IGW.id
    }
 }

# Route table Association with Public Subnet's
 resource "aws_route_table_association" "PublicRTassociation_1" {
    subnet_id = aws_subnet.publicsubnet_1.id
    route_table_id = aws_route_table.PublicRT.id
 }

  resource "aws_route_table_association" "PublicRTassociation_2" {
      subnet_id = aws_subnet.publicsubnet_2.id
      route_table_id = aws_route_table.PublicRT.id
  }

  resource "aws_route_table_association" "PublicRTassociation_3" {
      subnet_id = aws_subnet.publicsubnet_3.id
      route_table_id = aws_route_table.PublicRT.id
  }