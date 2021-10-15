resource "aws_security_group" "instance" {
  description = "Security group for Mythical API instances"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_traffic_for_app" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port   = "8000"
  to_port     = "8000"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_outbound_traffic_instance" {
  type              = "egress"
  security_group_id = aws_security_group.instance.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}