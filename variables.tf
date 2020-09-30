## variables.tf

## Region
variable "region" {
  description = "Region"
  type        = string
  default     = "us-east-1"
}

##  ELB
#ELB Name
variable "lb_name" {
  description = "Load Balancer Name"
  default     = "LB-1"
}

#ELB -internal or external
variable "lb_internal" {
  description = "Boolean determining if the load balancer is internal or externally facing."
  type        = bool
  default     = true
}

#LB-Type
variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application or network."
  type        = string
  default     = "application"
}

#LB SGs
variable "lb_security_groups" {
  description = "A comma seperated Security Groups."
  type        = string
  default     = "application"
}

#LB-Subnets
variable "lb_az_subnets" {
  description = "A comma seperated Subnets. single subnet from an AZ"
  type        = string
  default     = "application"
}

#LB - is https only ?
variable "use_https_only"{
  description = "Set to true if only https i,e http redirect to https."
  type        = bool
  default     = false
}

#LB - If https then define AWS "ACM ARN"
variable "ssl_certificate_arn" {
  description = "https ssl certitificate ACM arn"
  default = ""
}

## Target Group
variable "tg_name" {
  description = "Target Group Name"
  default     = "TG-1"
}

variable "tg_type" {
  description = "Target Group Type"
  default     = "instance"
}

variable "tg_port" {
  type        = number
  description = "The port to use to connect with the target."
}

variable "tg_protocol" {
  description = "The protocol to use to connect with the target."
  default     = "HTTP"
}

# health check
variable "tg_health_check_port" {
  type        = number
  description = "health check port"
  default     = 80
}

variable "tg_health_check_path" {
  type        = string
  description = "The destination for the health check request."
  default     = "/"
}

variable "tg_health_check_healthy_threshold" {
  type        = number
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy."
  default     = 5
}

variable "tg_health_check_unhealthy_threshold" {
  type        = number
  description = "The number of consecutive health check failures required before considering the target unhealthy."
  default     = 2
}

variable "tg_health_check_timeout" {
  type        = number
  description = "The amount of time, in seconds, during which no response means a failed health check."
  default     = 5
}

variable "tg_health_check_interval" {
  type        = number
  description = "The approximate amount of time, in seconds, between health checks of an individual target."
  default     = 30
}

variable "tg_health_check_success_code" {
  type        = number
  description = "Possible successful response from a target"
  default     = 200
}

## EC2 Instance & Autoscaling group details
#AMI-ID
variable "image_id" {
  description = "The EC2 image ID to launch"
}

#Type
variable "instance_type" {
  description = "Instance type to launch"
  default     = "t2.medium"
}

#Profile
variable "iam_instance_profile_name" {
  description = "The IAM instance profile name to associate with launched instances"
}

#KEY pair
variable "key_name" {
  type        = string
  description = "The SSH key name that should be used for the instance"
}

#User Data
variable "user_data" {
  description = "The path to a file with user_data for the instances"
}

#SG Ids
variable "ec2_security_group_ids" {
  description = "A comma seperated list of associated security group IDs."
}

## Autoscaling Group
#ASG Name
variable "asg_name" {
  type        = string
  description = "Autoscaling Group Name"
  default     = "ASG-1"
}
#Launch Config Name
variable "as_launch_config_name" {
  type        = string
  description = "Autoscaling launch config Name"
  default     = "ASG-1-LC-1"
}

#ASG - MIN EC2 instance size
variable "asg_max_size" {
  description = "The maximum size of the autoscale group"
  type        = number
  default     = 3
}

#ASG - MIN EC2 instance size
variable "asg_min_size" {
  type        = number
  description = "The minimum size of the autoscale group"
  default     = 2
}

#ASG -
variable "asg_desired_capacity" {
  type        = number
  description = "The number of Amazon EC2 instances that should be running in the group."
  default     = 3
}

#vpcid
variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed."
  type        = string
}

#Subnet
variable "asg_vpc_zone_subnets" {
  description = "A comma seperated list string of VPC subnets to associate with AZ, only one subnet per AZ."
  type        = string
}

#ASG - health check type
variable "health_check_type" {
  type        = string
  description = "Controls how health checking is done. Valid values are `EC2` or `ELB`"
  default     = "EC2"
}

#
variable "health_check_grace_period" {
  description = "Number of seconds for a health check to time out"
  default = 300
}

## END ##