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

# Create a .pem file
# RSA key of size 2048 bits
resource "tls_private_key" "new-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "private_key" {
  filename          = "${var.namespace}-key.pem"
  content = tls_private_key.new-key.private_key_pem
  file_permission   = "0700"
}


# Create a Key Pair
resource "aws_key_pair" "devkey" {
  key_name   = "ayomide-key"
  public_key = tls_private_key.new-key.public_key_openssh
# public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCldJxUMlogWB1Uu9/aDYFttIQZi1qP4H1BvfYmlbAKqWlAE3aGODI2MHytxvUk9j8BM7LI3+MibMASRSnXGX6UkHsg+3Vorsj6Nq/n2zjLjqLD6PqE+ijoNx6bjRmgztP7iTgfIBYplu6snT0MXCPXUIEUfMZyh2s251RdBEvaJuf/IgmUmssxbT9juToxjKLHmQGOcH4HmsGt33b5G3JL9KMidA3ACmrNZOZzDl48ZbQYaPLCqOVITC9fz9zo2Zlzzp27CJu4Drw15ycvkK2/nsjL9rBbxjhJigqgZWtHRwphg2OtQsYzXoe8OeCqx/Is2QSiTD6J4mUq2WrL2UdP2/CscPt1W543SwGl1k8hloze3dHlgWEjgGZlLbmx9APiHwsrX7vNZkpCi4vCsCVHdiygnOqQxHnNKKNYVTpojxVPym4ElYlx1hurCN6ndMbneeRjYfB29yB5vNc2YgV7oN+HgkOB3PYWp9y+NdBXXFcMmGegMa8y9H9d6qTrINE= vagrant@ubuntu-focal"
}


# Create EC2 instances
resource "aws_instance" "web_1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.publicsubnet_1.id
  vpc_security_group_ids = [aws_security_group.web_server_SG.id]
  depends_on = [
    aws_key_pair.devkey
    ]
  key_name = "ayomide-key"
  tags = {
    Name = "Altschool"
  }
}

resource "aws_instance" "web_2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.publicsubnet_2.id
  vpc_security_group_ids = [aws_security_group.web_server_SG.id]
  depends_on = [
    aws_key_pair.devkey
    ]
  key_name = "ayomide-key"
  tags = {
    Name = "Altschool"
  }
}

resource "aws_instance" "web_3" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.publicsubnet_3.id
  vpc_security_group_ids = [aws_security_group.web_server_SG.id]
  depends_on = [
    aws_key_pair.devkey
  ]
  key_name = "ayomide-key"
  tags = {
    Name = "Atlschool-mini-project"
  }
}

# Create an EBS volume
resource "aws_ebs_volume" "ebs_vol_1" {
  availability_zone = var.availability_zones[0]
  size              = 10
}

resource "aws_ebs_volume" "ebs_vol_2" {
  availability_zone = var.availability_zones[1]
  size              = 10
}

resource "aws_ebs_volume" "ebs_vol_3" {
  availability_zone = var.availability_zones[2]
  size              = 10
}

resource "aws_volume_attachment" "ebs_att_1" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs_vol_1.id
  instance_id = aws_instance.web_1.id
}

resource "aws_volume_attachment" "ebs_att_2" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs_vol_2.id
  instance_id = aws_instance.web_2.id
}

resource "aws_volume_attachment" "ebs_att_3" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs_vol_3.id
  instance_id = aws_instance.web_3.id
}

# Create a Load Balancer
resource "aws_lb" "alb" {
  name               = "royalboe"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_SG.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

  tags = {
    Name = "alb"
  }
}

# Create a Target Group
resource "aws_lb_target_group" "alb_target_group" {
  name     = "royalboe-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Altschool_Net.id
  target_type = "instance"

  health_check {
    enabled =  true
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval            = 10
    matcher = "200-399"
    protocol = "HTTP"
    port     = "traffic-port"
    timeout             = 3
    path                = "/"
  }
}

# Create load balancer listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

# Register Targets
resource "aws_lb_target_group_attachment" "alb_target_group_attachment_1" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.web_1.id
  port             = 80
  availability_zone = var.availability_zones[0]
}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment_2" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.web_2.id
  port             = 80
  availability_zone = var.availability_zones[1]
}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment_3" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.web_3.id
  port             = 80
  availability_zone = var.availability_zones[2]
}

# Create a Route53 Zone
resource "aws_route53_zone" "my_zone" {
  name = "royalboe.com"
  vpc_id = aws_vpc.Altschool_Net.id
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