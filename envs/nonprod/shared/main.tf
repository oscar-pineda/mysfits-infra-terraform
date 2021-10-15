terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.63"
    }
  }

  #backend "s3" {}
}

provider "aws" {
  region = var.region
}

module "common_data" {
  source = "../../../modules/common-data"

  domain_name = var.domain_name
}

module "tls_cert" {
  source = "../../../modules/tls-cert"

  domain_name               = var.domain_name
  route53_zone_id           = module.common_data.route53_zone_id
  subject_alternative_names = [for subdomain in var.subdomains : "${subdomain}.${var.domain_name}"]
}

module "loadbalancer" {
  source = "../../../modules/loadbalancer"

  name            = var.loadbalancer_name
  cert_arn        = module.tls_cert.cert_arn
  security_groups = [aws_security_group.load_balancer.id]
  subnets         = module.common_data.default_subnet_ids
}

resource "aws_codedeploy_app" "app" {
  name = var.codedeploy_app_name
}