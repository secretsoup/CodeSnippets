variable "stored_management_group_id" {
  type = string
}

## This needs to be the full address i.e. /providers/Microsoft.Management/managementGroups/MGNAME
variable "applied_scope_id" {
  type = string
}

variable "identity_location" {
  type = string
}
