terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
}

locals {
  app_dns = "${var.subdomain}.${var.domain_name}"
}

module "common_data" {
  source = "../../../modules/common-data"

  domain_name = var.domain_name
}

module "target_group" {
  source = "../../../modules/target-group"

  name         = replace(var.subdomain, ".", "-")
  port         = var.port
  vpc_id       = module.common_data.default_vpc_id
  listener_arn = var.lb_listener_arn
  host_headers = [local.app_dns]
}

module "compute" {
  source = "../../../modules/compute"

  ami_id               = var.ami_id == "latest" ? module.common_data.amazon_linux_2_ami_id : var.ami_id
  instance_type        = var.instance_type
  vpc_id               = module.common_data.default_vpc_id
  region               = var.region
  env                  = var.env
  key_name             = var.key_name
  asg_min_size         = var.asg_min_size
  asg_max_size         = var.asg_max_size
  asg_desired_capacity = var.asg_desired_capacity
  security_groups      = [var.sg_instance_id, var.sg_ssh_id]
  iam_instance_profile = var.instance_profile_name
  subnets              = module.common_data.default_subnet_ids
}

resource "aws_route53_record" "record" {
  zone_id = module.common_data.route53_zone_id
  name    = var.subdomain
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = false
  }
}
