# Create a Load Balancer
resource "aws_lb" "alb" {
  name               = "royalboe"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_SG.id]
  subnets            = [aws_subnet.publicsubnet_1.id, aws_subnet.publicsubnet_2.id, aws_subnet.publicsubnet_3.id]

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
  # availability_zone = var.availability_zones[0]
}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment_2" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.web_2.id
  port             = 80
  # availability_zone = var.availability_zones[1]
}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment_3" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.web_3.id
  port             = 80
  # availability_zone = var.availability_zones[2]
}