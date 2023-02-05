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
