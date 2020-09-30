# Launch Config ID
output "launch_config_id" {
    value = "${aws_launch_configuration.launch_config.id}"
}

# Auto Scaling ID
output "asg_id" {
    value = "${aws_autoscaling_group.asg.id}"
}

# Load Balancer ID
output "load_balancer_id" {
    value = "${aws_lb.alb.id}"
}

# Target Group ID
output "target_group_id" {
    value = "${aws_lb_target_group.target_group.id}"
}

## END
