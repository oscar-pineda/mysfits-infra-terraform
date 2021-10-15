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
  name_prefix        = var.instance_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.tust_policy_ec2.json

  inline_policy {
    name = "s3permissions"

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


#--------------------------------------------------------------
# CodeDeploy Service Role
#--------------------------------------------------------------
data "aws_iam_policy_document" "tust_policy_codedeploy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codedeploy_role" {
  name_prefix        = var.codedeploy_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.tust_policy_codedeploy.json
}


data "aws_iam_policy" "AWSCodeDeployRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role_policy_attachment" "codedeploy_role_attachment" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = data.aws_iam_policy.AWSCodeDeployRole.arn
}
