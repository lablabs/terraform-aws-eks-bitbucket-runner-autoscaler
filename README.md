# Bitbucket Runner Autoscaler
This module deploys a Helm chart for the Bitbucket runner autoscaler and supports deploying Bitbucket runner groups, as well as the AWS IAM components needed for Bitbucket runners to authenticate against AWS resources.

## Cross-Account IAM Access for Runners
You have two options for setting up cross-account IAM access:

- Create an IAM Role and OIDC Provider in Another AWS Account: Set up an IAM role and OIDC provider for the same Bitbucket workspace in your other AWS account, and then assume that IAM role from your current account.

- Use the `additional_assumable_iam_roles` Variable: Utilize the additional\_assumable\_iam\_roles variable, which adds sts:AssumeRole permissions for the specified roles to the IAM role where your runners are deployed. In your pipelines, you can then assume roles deployed in your other AWS accounts.

## Use Specialized AWS IAM Roles for Runners
The IAM role created by this module is opinionated and limited, it can only interact with ECR images. If you require the capability to manage additional AWS services, it is advised to create separate IAM roles. Configure these roles with assume policy conditions that restrict authentication to specific repositories and environments within those repositories.

## OIDC Thumbprint
To generate the OIDC thumbprint for the Bitbucket provider, set by the `bitbucket_oidc_thumbprint` variable, follow [this guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html).

[![Terraform validate](https://github.com/lablabs/terraform-aws-eks-bitbucket-runner-autoscaler/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-bitbucket-runner-autoscaler/actions/workflows/validate.yaml)
[![pre-commit](https://github.com/lablabs/terraform-aws-eks-bitbucket-runner-autoscaler/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-bitbucket-runner-autoscaler/actions/workflows/pre-commit.yaml)

---

## Related Projects

Check out other [Terraform Kubernetes addons](https://github.com/orgs/lablabs/repositories?q=terraform-aws-eks&type=public&language=&sort=).

[<img src="https://lablabs.io/static/ll-logo.png" width=350px>](https://lablabs.io/)

We help companies build, run, deploy and scale software and infrastructure by embracing the right technologies and principles. Check out our website at <https://lablabs.io/>.

## Deployment methods

### Helm
Deploy Helm chart via Helm resource (default method, set `enabled = true`)

### Argo Kubernetes
Deploy Helm chart as ArgoCD Application via Kubernetes manifest resource (set `enabled = true` and `argo_enabled = true`)

> **Warning**
>
> When deploying with ArgoCD application, Kubernetes terraform provider requires access to Kubernetes cluster API during plan time. This introduces potential issue when you want to deploy the cluster with this addon at the same time, during the same Terraform run.
>
> To overcome this issue, the module deploys the ArgoCD application object using the Helm provider, which does not require API access during plan. If you want to deploy the application using this workaround, you can set the `argo_helm_enabled` variable to `true`.

### Argo Helm
Deploy Helm chart as ArgoCD Application via Helm resource (set `enabled = true`, `argo_enabled = true` and `argo_helm_enabled = true`)

## Examples

See [basic example](examples/basic) for further information.
Refer to the [IAM example](examples/basic/iam.tf) for guidance on creating an assume role policy for IAM roles with a more limited scope.
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.20.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 0.17.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_addon"></a> [addon](#module\_addon) | git::https://github.com/lablabs/terraform-aws-eks-universal-addon.git//modules/addon | v0.0.6 |
## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [utils_deep_merge_yaml.values](https://registry.terraform.io/providers/cloudposse/utils/latest/docs/data-sources/deep_merge_yaml) | data source |
> [!IMPORTANT]
> Variables defined in [variables-addon.tf](variables-addon.tf) defaults to `null` to have them overridable by the addon configuration defined though the [`local.addon.*`](main.tf) local variable with some default values defined in [addon.tf](addon.tf).
## Inputs

| Name | Description | Type |
|------|-------------|------|
| <a name="input_additional_assumable_iam_roles"></a> [additional\_assumable\_iam\_roles](#input\_additional\_assumable\_iam\_roles) | Additional IAM roles that the runner role can assume | `list(string)` |
| <a name="input_argo_apiversion"></a> [argo\_apiversion](#input\_argo\_apiversion) | ArgoCD Application apiVersion. Defaults to `"argoproj.io/v1alpha1"`. | `string` |
| <a name="input_argo_destination_server"></a> [argo\_destination\_server](#input\_argo\_destination\_server) | Destination server for ArgoCD Application. Defaults to `"https://kubernetes.default.svc"`. | `string` |
| <a name="input_argo_enabled"></a> [argo\_enabled](#input\_argo\_enabled) | If set to true, the module will be deployed as ArgoCD application, otherwise it will be deployed as a Helm release. Defaults to `false`. | `bool` |
| <a name="input_argo_helm_enabled"></a> [argo\_helm\_enabled](#input\_argo\_helm\_enabled) | If set to true, the ArgoCD Application manifest will be deployed using Kubernetes provider as a Helm release. Otherwise it'll be deployed as a Kubernetes manifest. See README for more info. Defaults to `false`. | `bool` |
| <a name="input_argo_helm_values"></a> [argo\_helm\_values](#input\_argo\_helm\_values) | Value overrides to use when deploying ArgoCD Application object with Helm. Defaults to `""`. | `string` |
| <a name="input_argo_helm_wait_backoff_limit"></a> [argo\_helm\_wait\_backoff\_limit](#input\_argo\_helm\_wait\_backoff\_limit) | Backoff limit for ArgoCD Application Helm release wait job. Defaults to `6`. | `number` |
| <a name="input_argo_helm_wait_node_selector"></a> [argo\_helm\_wait\_node\_selector](#input\_argo\_helm\_wait\_node\_selector) | Node selector for ArgoCD Application Helm release wait job. Defaults to `{}`. | `map(string)` |
| <a name="input_argo_helm_wait_timeout"></a> [argo\_helm\_wait\_timeout](#input\_argo\_helm\_wait\_timeout) | Timeout for ArgoCD Application Helm release wait job. Defaults to `"10m"`. | `string` |
| <a name="input_argo_helm_wait_tolerations"></a> [argo\_helm\_wait\_tolerations](#input\_argo\_helm\_wait\_tolerations) | Tolerations for ArgoCD Application Helm release wait job. Defaults to `[]`. | `list(any)` |
| <a name="input_argo_info"></a> [argo\_info](#input\_argo\_info) | ArgoCD info manifest parameter. Defaults to `[{name="terraform",value=true}]`. | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> |
| <a name="input_argo_kubernetes_manifest_computed_fields"></a> [argo\_kubernetes\_manifest\_computed\_fields](#input\_argo\_kubernetes\_manifest\_computed\_fields) | List of paths of fields to be handled as "computed". The user-configured value for the field will be overridden by any different value returned by the API after apply. Defaults to `["metadata.labels", "metadata.annotations", "metadata.finalizers"]`. | `list(string)` |
| <a name="input_argo_kubernetes_manifest_field_manager_force_conflicts"></a> [argo\_kubernetes\_manifest\_field\_manager\_force\_conflicts](#input\_argo\_kubernetes\_manifest\_field\_manager\_force\_conflicts) | Forcibly override any field manager conflicts when applying the kubernetes manifest resource. Defaults to `false`. | `bool` |
| <a name="input_argo_kubernetes_manifest_field_manager_name"></a> [argo\_kubernetes\_manifest\_field\_manager\_name](#input\_argo\_kubernetes\_manifest\_field\_manager\_name) | The name of the field manager to use when applying the Kubernetes manifest resource. Defaults to `"Terraform"`. | `string` |
| <a name="input_argo_kubernetes_manifest_wait_fields"></a> [argo\_kubernetes\_manifest\_wait\_fields](#input\_argo\_kubernetes\_manifest\_wait\_fields) | A map of fields and a corresponding regular expression with a pattern to wait for. The provider will wait until the field matches the regular expression. Use * for any value. Defaults to `{}`. | `map(string)` |
| <a name="input_argo_metadata"></a> [argo\_metadata](#input\_argo\_metadata) | ArgoCD Application metadata configuration. Override or create additional metadata parameters. Defaults to `{finalizers=["resources-finalizer.argocd.argoproj.io"]}`. | `any` |
| <a name="input_argo_namespace"></a> [argo\_namespace](#input\_argo\_namespace) | Namespace to deploy ArgoCD application CRD to. Defaults to `"argo"`. | `string` |
| <a name="input_argo_project"></a> [argo\_project](#input\_argo\_project) | ArgoCD Application project. Defaults to `default`. | `string` |
| <a name="input_argo_spec"></a> [argo\_spec](#input\_argo\_spec) | ArgoCD Application spec configuration. Override or create additional spec parameters. Defaults to `{}`. | `any` |
| <a name="input_argo_sync_policy"></a> [argo\_sync\_policy](#input\_argo\_sync\_policy) | ArgoCD syncPolicy manifest parameter. Defaults to `{}`. | `any` |
| <a name="input_bitbucket_oidc_thumbprint"></a> [bitbucket\_oidc\_thumbprint](#input\_bitbucket\_oidc\_thumbprint) | Bitbucket OIDC thumbprint | `string` |
| <a name="input_bitbucket_workspace_id"></a> [bitbucket\_workspace\_id](#input\_bitbucket\_workspace\_id) | Bitbucket workspace ID | `string` |
| <a name="input_bitbucket_workspace_uuid"></a> [bitbucket\_workspace\_uuid](#input\_bitbucket\_workspace\_uuid) | Bitbucket workspace UUID | `string` |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources. | `bool` |
| <a name="input_helm_atomic"></a> [helm\_atomic](#input\_helm\_atomic) | If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to `false`. | `bool` |
| <a name="input_helm_chart_name"></a> [helm\_chart\_name](#input\_helm\_chart\_name) | Helm chart name to be installed. Defaults to `local.addon.name` (required). | `string` |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Version of the Helm chart. Defaults to `local.addon.helm_chart_version` (required). | `string` |
| <a name="input_helm_cleanup_on_fail"></a> [helm\_cleanup\_on\_fail](#input\_helm\_cleanup\_on\_fail) | Allow deletion of new resources created in this Helm upgrade when upgrade fails. Defaults to `false`. | `bool` |
| <a name="input_helm_create_namespace"></a> [helm\_create\_namespace](#input\_helm\_create\_namespace) | Create the namespace if it does not yet exist. Defaults to `true`. | `bool` |
| <a name="input_helm_dependency_update"></a> [helm\_dependency\_update](#input\_helm\_dependency\_update) | Runs Helm dependency update before installing the chart. Defaults to `false`. | `bool` |
| <a name="input_helm_description"></a> [helm\_description](#input\_helm\_description) | Set Helm release description attribute (visible in the history). Defaults to `""`. | `string` |
| <a name="input_helm_devel"></a> [helm\_devel](#input\_helm\_devel) | Use Helm chart development versions, too. Equivalent to version '>0.0.0-0'. If version is set, this is ignored. Defaults to `false`. | `bool` |
| <a name="input_helm_disable_openapi_validation"></a> [helm\_disable\_openapi\_validation](#input\_helm\_disable\_openapi\_validation) | If set, the installation process will not validate rendered Helm templates against the Kubernetes OpenAPI Schema. Defaults to `false`. | `bool` |
| <a name="input_helm_disable_webhooks"></a> [helm\_disable\_webhooks](#input\_helm\_disable\_webhooks) | Prevent Helm chart hooks from running. Defaults to `false`. | `bool` |
| <a name="input_helm_force_update"></a> [helm\_force\_update](#input\_helm\_force\_update) | Force Helm resource update through delete/recreate if needed. Defaults to `false`. | `bool` |
| <a name="input_helm_keyring"></a> [helm\_keyring](#input\_helm\_keyring) | Location of public keys used for verification. Used only if `helm_package_verify` is `true`. Defaults to `"~/.gnupg/pubring.gpg"`. | `string` |
| <a name="input_helm_lint"></a> [helm\_lint](#input\_helm\_lint) | Run the Helm chart linter during the plan. Defaults to `false`. | `bool` |
| <a name="input_helm_package_verify"></a> [helm\_package\_verify](#input\_helm\_package\_verify) | Verify the package before installing it. Helm uses a provenance file to verify the integrity of the chart; this must be hosted alongside the chart. Defaults to `false`. | `bool` |
| <a name="input_helm_postrender"></a> [helm\_postrender](#input\_helm\_postrender) | Value block with a path to a binary file to run after Helm renders the manifest which can alter the manifest contents. Defaults to `{}`. | `map(any)` |
| <a name="input_helm_recreate_pods"></a> [helm\_recreate\_pods](#input\_helm\_recreate\_pods) | Perform pods restart during Helm upgrade/rollback. Defaults to `false`. | `bool` |
| <a name="input_helm_release_max_history"></a> [helm\_release\_max\_history](#input\_helm\_release\_max\_history) | Maximum number of release versions stored per release. Defaults to `0`. | `number` |
| <a name="input_helm_release_name"></a> [helm\_release\_name](#input\_helm\_release\_name) | Helm release name. Defaults to `local.addon.name` (required). | `string` |
| <a name="input_helm_render_subchart_notes"></a> [helm\_render\_subchart\_notes](#input\_helm\_render\_subchart\_notes) | If set, render Helm subchart notes along with the parent. Defaults to `true`. | `bool` |
| <a name="input_helm_replace"></a> [helm\_replace](#input\_helm\_replace) | Re-use the given name of Helm release, only if that name is a deleted release which remains in the history. This is unsafe in production. Defaults to `false`. | `bool` |
| <a name="input_helm_repo_ca_file"></a> [helm\_repo\_ca\_file](#input\_helm\_repo\_ca\_file) | Helm repositories CA cert file. Defaults to `""`. | `string` |
| <a name="input_helm_repo_cert_file"></a> [helm\_repo\_cert\_file](#input\_helm\_repo\_cert\_file) | Helm repositories cert file. Defaults to `""`. | `string` |
| <a name="input_helm_repo_key_file"></a> [helm\_repo\_key\_file](#input\_helm\_repo\_key\_file) | Helm repositories cert key file. Defaults to `""`. | `string` |
| <a name="input_helm_repo_password"></a> [helm\_repo\_password](#input\_helm\_repo\_password) | Password for HTTP basic authentication against the Helm repository. Defaults to `""`. | `string` |
| <a name="input_helm_repo_url"></a> [helm\_repo\_url](#input\_helm\_repo\_url) | Helm repository. Defaults to `local.addon.helm_repo_url` (required). | `string` |
| <a name="input_helm_repo_username"></a> [helm\_repo\_username](#input\_helm\_repo\_username) | Username for HTTP basic authentication against the Helm repository. Defaults to `""`. | `string` |
| <a name="input_helm_reset_values"></a> [helm\_reset\_values](#input\_helm\_reset\_values) | When upgrading, reset the values to the ones built into the Helm chart. Defaults to `false`. | `bool` |
| <a name="input_helm_reuse_values"></a> [helm\_reuse\_values](#input\_helm\_reuse\_values) | When upgrading, reuse the last Helm release's values and merge in any overrides. If 'helm\_reset\_values' is specified, this is ignored. Defaults to `false`. | `bool` |
| <a name="input_helm_set_sensitive"></a> [helm\_set\_sensitive](#input\_helm\_set\_sensitive) | Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff. Defaults to `{}`. | `map(any)` |
| <a name="input_helm_skip_crds"></a> [helm\_skip\_crds](#input\_helm\_skip\_crds) | If set, no CRDs will be installed before Helm release. Defaults to `false`. | `bool` |
| <a name="input_helm_timeout"></a> [helm\_timeout](#input\_helm\_timeout) | Time in seconds to wait for any individual Kubernetes operation (like Jobs for hooks). Defaults to `300`. | `number` |
| <a name="input_helm_wait"></a> [helm\_wait](#input\_helm\_wait) | Will wait until all Helm release resources are in a ready state before marking the release as successful. It will wait for as long as timeout. Defaults to `false`. | `bool` |
| <a name="input_helm_wait_for_jobs"></a> [helm\_wait\_for\_jobs](#input\_helm\_wait\_for\_jobs) | If wait is enabled, will wait until all Helm Jobs have been completed before marking the release as successful. It will wait for as long as timeout. Defaults to `false`. | `bool` |
| <a name="input_iam_oidc_provider_create"></a> [iam\_oidc\_provider\_create](#input\_iam\_oidc\_provider\_create) | Whether to create IAM OIDC provider for Bitbucket | `bool` |
| <a name="input_iam_role_create"></a> [iam\_role\_create](#input\_iam\_role\_create) | Whether to create IAM role for the runner | `bool` |
| <a name="input_iam_role_name_prefix"></a> [iam\_role\_name\_prefix](#input\_iam\_role\_name\_prefix) | The IAM role name prefix for the runner | `string` |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The Kubernetes Namespace in which the Helm chart will be installed. Defaults to `local.addon.name`. | `string` |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional Helm sets which will be passed to the Helm chart values. Defaults to `{}`. | `map(any)` |
| <a name="input_tags"></a> [tags](#input\_tags) | AWS IAM resources tags | `map(string)` |
| <a name="input_values"></a> [values](#input\_values) | Additional yaml encoded values which will be passed to the Helm chart. Defaults to `""`. | `string` |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_addon"></a> [addon](#output\_addon) | The addon module outputs |
## Contributing and reporting issues

Feel free to create an issue in this repository if you have questions, suggestions or feature requests.

### Validation, linters and pull-requests

We want to provide high quality code and modules. For this reason we are using
several [pre-commit hooks](.pre-commit-config.yaml) and
[GitHub Actions workflows](.github/workflows/). A pull-request to the
main branch will trigger these validations and lints automatically. Please
check your code before you will create pull-requests. See
[pre-commit documentation](https://pre-commit.com/) and
[GitHub Actions documentation](https://docs.github.com/en/actions) for further
details.

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.
