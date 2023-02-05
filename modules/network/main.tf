# data "aws_availability_zones" "zones" {
#   state = "available"
# }

# data "aws_availability_zones" "zones" {
#   state = "available"
# }
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

# Create a Security Group for the EC2 instance
resource "aws_security_group" "web_server_SG" {
  name        = "Altschool_SG"
  description = "Allow SSH HTPPS, and, HTTP traffic"
  vpc_id      = aws_vpc.Altschool_Net.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Altschool_SG"
  }
}

# Create a Security Group for the load balancer
resource "aws_security_group" "load_balancer_SG" {
  name        = "My_LB_SG"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.Altschool_Net.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "My_LB_SG"
  }
}