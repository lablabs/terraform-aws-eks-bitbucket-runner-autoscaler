# IMPORTANT: Add addon specific variables here
variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

# ================ Bitbucket variables (optional) ================
variable "bitbucket_workspace_name" {
  type        = string
  default     = ""
  description = "Bitbucket workspace name"
}

variable "bitbucket_workspace_uuid" {
  type        = string
  default     = ""
  description = "Bitbucket workspace UUID"
}
