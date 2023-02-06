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

# Create EC2 instances
resource "aws_instance" "web_1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = var.pub_subnets[0]
  vpc_security_group_ids = [var.web_server_SG]
  key_name = var.key_name
  tags = var.proj-tag
}

resource "aws_instance" "web_2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = var.pub_subnets[1]
  vpc_security_group_ids = [var.web_server_SG]
  key_name = var.key_name
  tags = var.proj-tag
}

resource "aws_instance" "web_3" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = var.pub_subnets[2]
  vpc_security_group_ids = [var.web_server_SG]
  key_name = var.key_name
  tags = var.proj-tag
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

aws_instance_state "web_1" {
  instance_id = aws_instance.web_1.id
  state = "running"
}

aws_instance_state "web_2" {
  instance_id = aws_instance.web_2.id
  state = "running"
}

aws_instance_state "web_3" {
  instance_id = aws_instance.web_3.id
  state = "running"
}
# Create a file to store the IP addresses of the instances
resource "local_file" "host-inventory" {
  filename = "./host-inventory"
  content  = <<EOT
${aws_instance.web_1.public_ip}
${aws_instance.web_2.public_ip}
${aws_instance.web_3.public_ip}
  EOT
}

resource "null_resource" "nulls" {
  depends_on = [aws_instance_state.web_1, aws_instance_state.web_2, aws_instance_state.web_3]
  # Run the ansible command for the hosts
  provisioner "local-exec" {
    command = "ansible-playbook -i host-inventory --private-key ${var.namespace}-key.pem main.yml"
  }
}