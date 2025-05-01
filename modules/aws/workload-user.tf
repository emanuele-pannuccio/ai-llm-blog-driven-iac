resource "aws_iam_user" "gcp-workloads" {
  for_each = toset(var.gcp.workloads)
  name     = "${var.prefix}-gcp-${each.key}"
  path     = "/"
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
    resources = [
      module.bastion-host.arn,
      "arn:aws:ssm:eu-west-1::document/AWS-StartPortForwardingSessionToRemoteHost"
    ]
  }
}

resource "aws_iam_user_policy_attachment" "AmazonEC2ReadOnlyAccess-iam-policy" {
  for_each   = toset(var.gcp.workloads)
  user       = aws_iam_user.gcp-workloads[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_user_policy_attachment" "AmazonSSMReadOnlyAccess-iam-policy" {
  for_each   = toset(var.gcp.workloads)
  user       = aws_iam_user.gcp-workloads[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_user_policy" "ssh-iam-policy" {
  for_each = toset(var.gcp.workloads)
  name     = "ssh-iam-policy"
  user     = aws_iam_user.gcp-workloads[each.key].name
  policy   = data.aws_iam_policy_document.ssh-policy.json
}
