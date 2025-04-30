resource "aws_iam_user" "gcp-workloads" {
  name = "${var.prefix}-gcp-workload"
  path = "/"
}

data "aws_iam_policy_document" "ssh-policy" {
  statement {
    effect = "Allow"
    actions = [
      # "ec2:*",
      # "ssm:*",
      "ssm:StartSession",
      "ssm:TerminateSession"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy_attachment" "AmazonEC2ReadOnlyAccess-iam-policy" {
  user       = aws_iam_user.gcp-workloads.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_user_policy_attachment" "AmazonSSMReadOnlyAccess-iam-policy" {
  user       = aws_iam_user.gcp-workloads.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_user_policy" "ssh-iam-policy" {
  name   = "ssh-iam-policy"
  user   = aws_iam_user.gcp-workloads.name
  policy = data.aws_iam_policy_document.ssh-policy.json
}
