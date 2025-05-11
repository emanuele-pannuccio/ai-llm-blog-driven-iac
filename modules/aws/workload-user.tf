data "aws_iam_policy_document" "ssh-policy" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:StartSession",
      "ssm:TerminateSession"
    ]
    resources = [
      module.bastion-host.arn,
      "arn:aws:ssm:eu-west-1::document/AWS-StartPortForwardingSessionToRemoteHost"
    ]
  }
}

resource "aws_iam_role_policy" "name" {
  for_each = toset(var.gcp.workloads)
  name     = "ssh-iam-policy"
  role     = aws_iam_role.gcp-workload[each.key].id
  policy   = data.aws_iam_policy_document.ssh-policy.json
}

resource "aws_iam_role" "gcp-workload" {
  for_each = toset(var.gcp.workloads)
  name     = "${var.prefix}-gcp-${each.key}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal : { Federated : "accounts.google.com" }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "accounts.google.com:aud" : each.key,
            "accounts.google.com:oaud" : each.key,
            "accounts.google.com:sub" : each.key
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ReadOnlyAccess-iam-policy" {
  for_each   = toset(var.gcp.workloads)
  role       = aws_iam_role.gcp-workload[each.key].id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}


resource "aws_iam_role_policy_attachment" "AmazonSSMReadOnlyAccess-iam-policy" {
  for_each   = toset(var.gcp.workloads)
  role       = aws_iam_role.gcp-workload[each.key].id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}
