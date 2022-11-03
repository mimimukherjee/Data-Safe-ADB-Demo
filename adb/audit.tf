data "oci_data_safe_audit_trails" "test_audit_trails" {
  #Required
  compartment_id = var.compartment_ocid

  #Optional
  #audit_trail_id            = oci_data_safe_audit_trail.test_audit_trail.id
  target_id = local.ds_target_id[0]
}

#resource "oci_data_safe_audit_trail" "test_audit_trail" {
  #Required
  #audit_trail_id =  local.audit_trail_id[0]
  #audit_trail_id =  local.audit_trail_id

  #Optional
  #state="ACTIVE"
  #description           = var.audit_trail_description
  #display_name          = var.audit_trail_display_name
  #freeform_tags         = var.audit_trail_freeform_tags
  #is_auto_purge_enabled = var.audit_trail_is_auto_purge_enabled
#}

data "oci_data_safe_audit_policies" "test_audit_policies" {
    #Required
    compartment_id = var.compartment_ocid

    #Optional
    #access_level = var.audit_policy_access_level
    #audit_policy_id = oci_data_safe_audit_policy.test_audit_policy.id
    #compartment_id_in_subtree = var.audit_policy_compartment_id_in_subtree
    #display_name = var.audit_policy_display_name
    #state = "ACTIVE"
    target_id = local.ds_target_id[0]
}

resource "oci_data_safe_audit_policy" "test_audit_policy" {
  #Required
  #audit_policy_id =  local.audit_policy_id[0]
  audit_policy_id =  local.audit_policy_id

  #Optional
  #description   = var.audit_policy_description
  #display_name  = var.audit_policy_display_name
  #freeform_tags = var.audit_policy_freeform_tags
}


data "oci_data_safe_audit_profiles" "test_audit_profiles" {
    #Required
    compartment_id = var.compartment_ocid

    #Optional
    #access_level = var.audit_profile_access_level
    #audit_collected_volume_greater_than_or_equal_to = var.audit_profile_audit_collected_volume_greater_than_or_equal_to
    #audit_profile_id = oci_data_safe_audit_profile.test_audit_profile.id
    #compartment_id_in_subtree = var.audit_profile_compartment_id_in_subtree
    #display_name = var.audit_profile_display_name
    #is_override_global_retention_setting = var.audit_profile_is_override_global_retention_setting
    #is_paid_usage_enabled = var.audit_profile_is_paid_usage_enabled
    #state = "ACTIVE"
    target_id = local.ds_target_id[0]
}

resource "oci_data_safe_audit_profile" "test_audit_profile" {
  #Required
  #audit_profile_id =  local.audit_profile_id[0]
  audit_profile_id =  local.audit_profile_id

  #Optional
  #description           = var.audit_profile_description
  #display_name          = var.audit_profile_display_name
  #freeform_tags         = var.audit_profile_freeform_tags
  #is_paid_usage_enabled = var.audit_profile_is_paid_usage_enabled
}

output "test_profile" {
  #value =  local.audit_profile_id[0]
  value =  local.audit_profile_id
}

output "test_trail" {
  #value =  local.audit_trail_id[0]
  value =  local.audit_trail_id
}

output "test_polciy" {
  #value =  local.audit_policy_id[0]
  value =  local.audit_policy_id
}

locals {
  #audit_profile_id = tolist([for each in data.oci_data_safe_audit_profiles.test_audit_profiles.audit_profile_collection[0].items : each.id if each.target_id == local.ds_target_id])
  #audit_trail_id = tolist([for each in data.oci_data_safe_audit_trails.test_audit_trails.audit_trail_collection[0].items : each.id if each.target_id == local.ds_target_id])
  #audit_policy_id = tolist([for each in data.oci_data_safe_audit_policies.test_audit_policies.audit_policy_collection[0].items : each.id if each.target_id == local.ds_target_id])
  audit_profile_id = data.oci_data_safe_audit_profiles.test_audit_profiles.audit_profile_collection[0].items[0].id
  audit_trail_id = data.oci_data_safe_audit_trails.test_audit_trails.audit_trail_collection[0].items[0].id
  audit_policy_id = data.oci_data_safe_audit_policies.test_audit_policies.audit_policy_collection[0].items[0].id
}

resource "null_resource" "audit_tasks" {
    provisioner "local-exec" {
        #command = "sh ${path.module}/script/audit.sh ${local.audit_trail_id[0]}  ${local.audit_profile_id[0]}  ${local.audit_policy_id[0]}"
        command = "sh ${path.module}/script/audit.sh ${local.audit_trail_id}  ${local.audit_profile_id}  ${local.audit_policy_id}"
    }
}

