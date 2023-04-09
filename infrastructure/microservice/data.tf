data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {}

data "aws_kms_key" "by_alias" {
  key_id = "alias/aws/ssm"
}

data "aws_iam_policy_document" "ecs_task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "logging_policy" {

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

data "aws_iam_policy_document" "ecr_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ecr:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ssm_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "kms:Decrypt"
    ]
    resources = [
      data.aws_kms_key.by_alias.arn,
      var.docdb_username_arn,
      var.docdb_password_arn
    ]
  }
}