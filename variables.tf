# IMPORTANT: Add addon specific variables here
variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

# ================ Bitbucket variables (optional) ================
variable "bitbucket_workspace_id" {
  type        = string
  default     = ""
  description = "Bitbucket workspace ID"
}

variable "bitbucket_workspace_uuid" {
  type        = string
  default     = ""
  description = "Bitbucket workspace UUID"
}

variable "bitbucket_oidc_thumbprint" {
  type        = string
  default     = ""
  description = "Bitbucket OIDC thumbprint"
}

# ================ IAM variables (optional) ================

variable "iam_role_create" {
  type        = bool
  default     = true
  description = "Whether to create IAM role for the runner"
}

variable "iam_oidc_provider_create" {
  type        = bool
  default     = true
  description = "Whether to create IAM OIDC provider for Bitbucket"
}

variable "iam_role_name_prefix" {
  type        = string
  default     = "bitbucket-runner-autoscaler"
  description = "The IAM role name prefix for the runner"
}

variable "additional_assumable_iam_roles" {
  type        = list(string)
  default     = []
  description = "Additional IAM roles that the runner role can assume"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS IAM resources tags"
}
