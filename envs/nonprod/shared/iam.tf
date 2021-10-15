#--------------------------------------------------------------
# Instance Role
#--------------------------------------------------------------
data "aws_iam_policy_document" "tust_policy_ec2" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance_role" {
  name_prefix        = "MythicalAPIInstanceRoleNonProd"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.tust_policy_ec2.json

  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:Get*", "s3:List*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = aws_iam_role.instance_role.name
  role = aws_iam_role.instance_role.name
}
