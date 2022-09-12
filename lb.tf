resource "aws_lb" "front_end" {
  name               = "front-end-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_presentation_tier.id]
  subnets            = aws_subnet.public_subnets.*.id

  enable_deletion_protection = false
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front_end.arn
  port              = "80"
  protocol          = "HTTP"
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}

resource "aws_lb_target_group" "front_end" {
  name     = "front-end-lb-tg"
  port     = 443
  protocol = "HTTPS"
  port              = "80"
  protocol          = "HTTP"
  vpc_id   = aws_vpc.vpc_name.id
}

resource "aws_lb" "application_tier" {
  name               = "application-tier-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_application_tier.id]
  subnets            = aws_subnet.private_subnets.*.id

  enable_deletion_protection = false
}

resource "aws_lb_listener" "application_tier" {
  load_balancer_arn = aws_lb.application_tier.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application_tier.arn
  }
}

resource "aws_lb_target_group" "application_tier" {
  name     = "application-tier-lb-tg"
  port     = "443"
  protocol = "HTTPS"
  vpc_id   = aws_vpc.vpc_name.id
}


#Creating Autoscaling Groups=========================================================================================================
resource "aws_autoscaling_group" "presentation_tier" {
  name                      = "Launch-Temp-ASG-Pres-Tier"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  vpc_zone_identifier       = aws_subnet.public_subnets.*.id

  launch_template {
    id      = aws_launch_template.presentation_tier.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key                 = "Name"
    value               = "presentation_app"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "application_tier" {
  name                      = "Launch-Temp-ASG-App-Tier"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  vpc_zone_identifier       = aws_subnet.private_subnets.*.id

  launch_template {
    id      = aws_launch_template.application_tier.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key                 = "Name"
    value               = "application_app"
    propagate_at_launch = true
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "presentation_tier" {
  autoscaling_group_name = aws_autoscaling_group.presentation_tier.id
  lb_target_group_arn    = aws_lb_target_group.front_end.arn
}

resource "aws_autoscaling_attachment" "application_tier" {
  autoscaling_group_name = aws_autoscaling_group.application_tier.id
  lb_target_group_arn    = aws_lb_target_group.application_tier.arn
}