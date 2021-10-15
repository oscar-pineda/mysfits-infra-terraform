
resource "aws_launch_configuration" "lc" {
  name_prefix          = "mythicalapi"
  image_id             = var.ami_id
  instance_type        = var.instance_type
  security_groups      = var.security_groups
  key_name             = var.key_name == "" ? null : var.key_name
  user_data            = templatefile("${path.module}/files/user-data.sh.tpl", { region = var.region })
  iam_instance_profile = var.iam_instance_profile

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = aws_launch_configuration.lc.name
  launch_configuration = aws_launch_configuration.lc.id
  vpc_zone_identifier  = var.subnets
  target_group_arns    = var.target_group_arns

  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity

  tag {
    key                 = "Name"
    value               = "MythicalAPIInstance-${var.env}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}