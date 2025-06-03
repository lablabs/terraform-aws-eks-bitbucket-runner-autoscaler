/**
 * # Bitbucket Runner Autoscaler
 *
 * This module deploys a Helm chart for the Bitbucket runner autoscaler and supports deploying Bitbucket runner groups, as well as the AWS IAM components needed for Bitbucket runners to authenticate against AWS resources.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-bitbucket-runner-autoscaler/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-bitbucket-runner-autoscaler/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-bitbucket-runner-autoscaler/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-bitbucket-runner-autoscaler/actions/workflows/pre-commit.yaml)
 */
locals {
  addon = {
    name               = "bitbucket-runner-autoscaler"
    namespace          = "bitbucket-runner-autoscaler"
    helm_release_name  = "bitbucket-runner-autoscaler"
    helm_chart_name    = "bitbucket-runner-autoscaler"
    helm_chart_version = "0.2.0"
    helm_repo_url      = "https://lablabs.github.io/bitbucket-runner-autoscaler-helm-chart/"

    bitbucket_openid_provider_url = "api.bitbucket.org/2.0/workspaces/${var.bitbucket_workspace_name}/pipelines-config/identity/oidc"
  }

  addon_oidc = {
    (local.addon.name) = {
      oidc_openid_provider_url                   = local.addon.bitbucket_openid_provider_url
      oidc_openid_client_ids                     = ["ari:cloud:bitbucket::workspace/${var.bitbucket_workspace_uuid}"]
      oidc_openid_thumbprints                    = ["a031c46782e6e6c662c2c87c76da9aa62ccabd8e"] # pragma: allowlist secret
      oidc_assume_role_policy_condition_values   = ["*"]
      oidc_assume_role_policy_condition_variable = "${local.addon.bitbucket_openid_provider_url}:sub"
      oidc_assume_role_policy_condition_test     = "StringLike"
    }
  }

  addon_values = yamlencode({
    runner = {
      config = {
        constants = {
          default_sleep_time_runner_setup  = 10  # value in seconds
          default_sleep_time_runner_delete = 5   # value in seconds
          runner_api_polling_interval      = 600 # value in seconds
          runner_cool_down_period          = 300 # value in seconds
        }
      }
    }
  })

  addon_depends_on = []
}
