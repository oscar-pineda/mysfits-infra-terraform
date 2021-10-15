output "amazon_linux_2_ami_id" {
  value = data.aws_ami.amazon_linux_2.id
}

output "default_vpc_id" {
  value = aws_default_vpc.default.id
}

output "azs" {
  value = data.aws_availability_zones.available.names
}

output "default_subnet_ids" {
  value = [for s in aws_default_subnet.subnets : s.id]
}

output "route53_zone_id" {
  value = data.aws_route53_zone.selected.zone_id
}