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
variable "sg_instance_id" {}
variable "sg_ssh_id" {}
variable "instance_profile_name" {}