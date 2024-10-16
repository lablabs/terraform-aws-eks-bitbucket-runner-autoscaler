locals {
  iam_role_create = var.enabled && var.iam_role_create

  bitbucket_openid_provider_url = "api.bitbucket.org/2.0/workspaces/${var.bitbucket_workspace_id}/pipelines-config/identity/oidc"
}

resource "aws_iam_openid_connect_provider" "main" {
  count = var.iam_oidc_provider_create ? 1 : 0
  url   = "https://${local.bitbucket_openid_provider_url}"

  client_id_list = [
    "ari:cloud:bitbucket::workspace/${var.bitbucket_workspace_uuid}",
  ]

  thumbprint_list = [var.bitbucket_oidc_thumbprint]
  tags            = var.tags
}

data "aws_iam_policy_document" "main" {
  count = local.iam_role_create ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.main[0].arn]
    }

    condition {
      test     = "StringLike"
      variable = "${local.bitbucket_openid_provider_url}:sub"

      values = [
        "*",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "main" {
  count              = local.iam_role_create ? 1 : 0
  name               = "${var.iam_role_name_prefix}-${local.addon_helm_chart_name}"
  assume_role_policy = data.aws_iam_policy_document.main[0].json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "ecr" {
  count      = local.iam_role_create ? 1 : 0
  role       = aws_iam_role.main[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

data "aws_iam_policy_document" "assume" {
  count = local.iam_role_create && length(var.additional_assumable_iam_roles) > 0 ? 1 : 0

  statement {
    sid    = "AllowAssumeUniversalAddonRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = var.additional_assumable_iam_roles
  }
}

resource "aws_iam_policy" "assume" {
  count = local.iam_role_create && length(var.additional_assumable_iam_roles) > 0 ? 1 : 0

  name        = "${var.iam_role_name_prefix}-${local.addon_helm_chart_name}-assume"
  path        = "/"
  description = "Policy for Bitbucket runner to assume additional roles"
  policy      = data.aws_iam_policy_document.assume[0].json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "assume" {
  count      = local.iam_role_create && length(var.additional_assumable_iam_roles) > 0 ? 1 : 0
  role       = aws_iam_role.main[0].name
  policy_arn = aws_iam_policy.assume[0].arn
}
