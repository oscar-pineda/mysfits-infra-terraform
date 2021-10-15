#--------------------------------------------------------------
# Instance SG
#--------------------------------------------------------------
resource "aws_security_group" "instance" {
  description = "Security group for Mythical API instances"
  vpc_id      = module.common_data.default_vpc_id
}

resource "aws_security_group_rule" "instance_app" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id

  from_port                = "8000"
  to_port                  = "8000"
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.load_balancer.id
}

resource "aws_security_group_rule" "instance_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.instance.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

#--------------------------------------------------------------
# SSH SG
#--------------------------------------------------------------
resource "aws_security_group" "ssh" {
  description = "Security group for SSH"
  vpc_id      = module.common_data.default_vpc_id
}

resource "aws_security_group_rule" "ssh_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.ssh.id

  from_port   = "22"
  to_port     = "22"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

#--------------------------------------------------------------
# Load Balancer SG
#--------------------------------------------------------------
resource "aws_security_group" "load_balancer" {
  description = "Security group for Mythical Load Balancer"
  vpc_id      = module.common_data.default_vpc_id
}

resource "aws_security_group_rule" "lb_http" {
  type              = "ingress"
  security_group_id = aws_security_group.load_balancer.id

  from_port   = "80"
  to_port     = "80"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_https" {
  type              = "ingress"
  security_group_id = aws_security_group.load_balancer.id

  from_port   = "443"
  to_port     = "443"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.load_balancer.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
