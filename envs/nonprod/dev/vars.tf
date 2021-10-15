variable "region" {}
variable "env" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {
  default = ""
}
variable "asg_min_size" {}
variable "asg_max_size" {}
variable "asg_desired_capacity" {}
variable "domain_name" {}
variable "subdomain" {}
variable "sg_instance_id" {}
variable "sg_ssh_id" {}
variable "instance_profile_name" {}
variable "lb_listener_arn" {}
variable "lb_dns_name" {}
variable "lb_zone_id" {}