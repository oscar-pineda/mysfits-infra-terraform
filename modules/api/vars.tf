variable "ami_id" {}
variable "instance_type" {}
variable "vpc_id" {}
variable "region" {}
variable "env" {}
variable "key_name" {}
variable "asg_min_size" {}
variable "asg_max_size" {}
variable "asg_desired_capacity" {}
variable "subnets" {
  type = list(any)
}