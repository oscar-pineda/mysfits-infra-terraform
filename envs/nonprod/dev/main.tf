terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
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

module "api" {
  source = "../../../modules/api"
}

output "data" {
  value = module.common_data
}
