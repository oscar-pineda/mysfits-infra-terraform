terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
    }
  }

  # backend "s3" {}
}

provider "aws" {
  region = var.region
}

module "common_data" {
  source = "../../../modules/common-data"
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

output "data" {
  value = module.common_data
}
