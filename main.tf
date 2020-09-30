# main.tf

## Provider
provider "aws" {
  region = var.region
}

## Create ALB
resource "aws_lb" "alb" {
  name                       = var.lb_name
  internal                   = var.lb_internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = [var.lb_security_groups]
  subnets                    = split(",", var.lb_az_subnets)
  enable_deletion_protection = false
}

## Create Target Group
resource "aws_lb_target_group" "target_group" {
  name                 = var.tg_name
  target_type          = var.tg_type
  port                 = var.tg_port
  protocol             = var.tg_protocol
  vpc_id               = var.vpc_id

  health_check {
    enabled              = true
    port                = var.tg_health_check_port
    interval            = var.tg_health_check_interval
    healthy_threshold   = var.tg_health_check_healthy_threshold
    unhealthy_threshold = var.tg_health_check_unhealthy_threshold
    timeout             = var.tg_health_check_timeout
    path                = var.tg_health_check_path
    matcher             = var.tg_health_check_success_code
  }
}

## LB http, If use_https_only => false
resource "aws_lb_listener" "lb_listener" {
  count = var.use_https_only == "true" ? 0 : 1

  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action  {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

## LB redirect http to https, If use_https_only => true
resource "aws_lb_listener" "lb_listener_redirect_http" {
  count = var.use_https_only == "true" ? 1 : 0

  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action  {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

}

## https listeners when ssl_certificate_arn defined
resource "aws_lb_listener" "lb_listener_https" {
  count = var.ssl_certificate_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_certificate_arn
(dt.datetime.now(pytz.timezone('Asia/Kolkata')) + dt.timedelta(7)).strftime('%Y-%m-%d')
  default_action  {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

## Create - launch configuration template
resource "aws_launch_configuration" "launch_config" {
  name                 = var.as_launch_config_name
  image_id             = var.image_id
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_instance_profile_name
  key_name             = var.key_name
  security_groups      = split(",", var.ec2_security_group_ids)
  user_data            = file(var.user_data)
}

## Create - Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  depends_on                = [aws_launch_configuration.launch_config]
  name                      = var.asg_name
  launch_configuration      = aws_launch_configuration.launch_config.id

  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity

  vpc_zone_identifier       = split(",", var.asg_vpc_zone_subnets)

  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type

  target_group_arns         = [aws_lb_target_group.target_group.arn]
}

## END ##