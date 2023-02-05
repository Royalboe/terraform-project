# Create a Load Balancer
resource "aws_lb" "alb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.lb_sec_grps
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = var.proj-tag
}

# Create a Target Group
resource "aws_lb_target_group" "alb_target_group" {
  name     = "${var.namespace}-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
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
  target_id        = var.web_ids[0]
  port             = 80
  # availability_zone = var.availability_zones[0]
}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment_2" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = var.web_ids[1]
  port             = 80
  # availability_zone = var.availability_zones[1]
}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment_3" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = var.web_ids[2]
  port             = 80
  # availability_zone = var.availability_zones[2]
}