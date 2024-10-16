data "aws_iam_policy_document" "main" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["api.bitbucket.org/2.0/workspaces/{your-workspace-id}/pipelines-config/identity/oidc"]
    }

    condition {
      test     = "StringLike"
      variable = "ari:cloud:bitbucket::workspace/{your-workspace-uuid}:sub"

      values = [
        "{your-repository-uuid}:{your-environment-uuid}",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "main" {
  name               = "bitbucket-production"
  assume_role_policy = data.aws_iam_policy_document.main.json
}
