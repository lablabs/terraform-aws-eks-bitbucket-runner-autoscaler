## Cross-Account IAM Access for Runners
You have two options for setting up cross-account IAM access:

- Create an IAM Role and OIDC Provider in Another AWS Account: Set up an IAM role and OIDC provider for the same Bitbucket workspace in your other AWS account, and then assume that IAM role from your current account.

- Use the `additional_assumable_iam_roles` Variable: Utilize the additional_assumable_iam_roles variable, which adds sts:AssumeRole permissions for the specified roles to the IAM role where your runners are deployed. In your pipelines, you can then assume roles deployed in your other AWS accounts.

## Use Specialized AWS IAM Roles for Runners
The IAM role created by this module is opinionated and limited, it can only interact with ECR images. If you require the capability to manage additional AWS services, it is advised to create separate IAM roles. Configure these roles with assume policy conditions that restrict authentication to specific repositories and environments within those repositories. Refer to the [IAM example](iam.tf) for guidance on creating an assume role policy for IAM roles with a more limited scope.

## OIDC Thumbprint
To generate the OIDC thumbprint for the Bitbucket provider, set by the `bitbucket_oidc_thumbprint` variable, follow [this guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html).
