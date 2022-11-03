variable "tenancy_ocid" {}
variable "region" {}
variable "compartment_ocid" {}

variable "user_ocid" {
  default = ""
}
variable "fingerprint" {
  default = ""
}
variable "private_key_path" {
  default = ""
}

# Autonomous Database
variable "autonomous_database_name" {
  default = "demoadb"
}
variable "autonomous_database_db_version" {
  default = "19c"
}
variable "autonomous_database_license_model" {
  default = "LICENSE_INCLUDED"
}
variable "autonomous_database_is_free_tier" {
  default = false
}
variable "autonomous_database_cpu_core_count" {
  default = 1
}
variable "autonomous_database_data_storage_size_in_tbs" {
  default = 1
}
variable "autonomous_database_visibility" {
  default = "Public"
}
variable "autonomous_database_wallet_generate_type" {
  default = "SINGLE"
}
variable "autonomous_database_db_workload" {
  default = "OLTP"
}
variable "autonomous_database_freeform_tags" {
  default = {
    "Department" = "HR"
  }
}

# Always Free only or support other shapes
variable "use_only_always_free_eligible_resources" {
  default = true
}

## Always Free Locals
locals {
  autonomous_database_is_free_tier = var.use_only_always_free_eligible_resources ? true : var.autonomous_database_is_free_tier
}

