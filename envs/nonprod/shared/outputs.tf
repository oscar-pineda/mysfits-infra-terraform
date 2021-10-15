output "sg_instance_id" {
  value = aws_security_group.instance.id
}

output "sg_lb_id" {
  value = aws_security_group.load_balancer.id
}

output "sg_ssh_id" {
  value = aws_security_group.ssh.id
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.instance_profile.name
}

output "lb_listener_arn" {
  value = module.loadbalancer.lb_listener_arn
}

output "lb_dns" {
  value = module.loadbalancer.lb_dns
}
