/**
 * # Bitbucket Runner Autoscaler
 * This module deploys a Helm chart for the Bitbucket runner autoscaler and supports deploying Bitbucket runner groups, as well as the AWS IAM components needed for Bitbucket runners to authenticate against AWS resources.
 *
 * ## Cross-Account IAM Access for Runners
 * You have two options for setting up cross-account IAM access:
 *
 * - Create an IAM Role and OIDC Provider in Another AWS Account: Set up an IAM role and OIDC provider for the same Bitbucket workspace in your other AWS account, and then assume that IAM role from your current account.
 *
 * - Use the `additional_assumable_iam_roles` Variable: Utilize the additional_assumable_iam_roles variable, which adds sts:AssumeRole permissions for the specified roles to the IAM role where your runners are deployed. In your pipelines, you can then assume roles deployed in your other AWS accounts.
 *
 * ## Use Specialized AWS IAM Roles for Runners
 * The IAM role created by this module is opinionated and limited, it can only interact with ECR images. If you require the capability to manage additional AWS services, it is advised to create separate IAM roles. Configure these roles with assume policy conditions that restrict authentication to specific repositories and environments within those repositories.
 *
 * ## OIDC Thumbprint
 * To generate the OIDC thumbprint for the Bitbucket provider, set by the `bitbucket_oidc_thumbprint` variable, follow [this guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html).
 *
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-bitbucket-runner-autoscaler/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-bitbucket-runner-autoscaler/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-bitbucket-runner-autoscaler/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-bitbucket-runner-autoscaler/actions/workflows/pre-commit.yaml)
 */

locals {
  addon = {
    name = "bitbucket-runner-autoscaler"

    helm_chart_name    = "bitbucket-runner-autoscaler"
    helm_chart_version = "0.1.0"
    helm_repo_url      = "https://lablabs.github.io/bitbucket-runner-autoscaler-helm-chart/"
  }

  addon_values = yamlencode({})
}
