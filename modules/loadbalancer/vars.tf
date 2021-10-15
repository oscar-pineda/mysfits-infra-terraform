variable "name" {}
variable "cert_arn" {}
variable "security_groups" {
  type = list(any)
}
variable "subnets" {
  type = list(any)
}