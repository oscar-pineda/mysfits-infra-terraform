variable "domain_name" {}
variable "route53_zone_id" {}
variable "subject_alternative_names" {
  type = list(any)
}