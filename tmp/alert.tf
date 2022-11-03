data "oci_data_safe_alert_policies" "test_alert_policies" {
    #Required
    compartment_id = var.compartment_ocid

    #Optional
    #access_level = var.alert_policy_access_level
    #alert_policy_id = oci_data_safe_alert_policy.test_alert_policy.id
    #compartment_id_in_subtree = var.alert_policy_compartment_id_in_subtree
    #display_name = var.alert_policy_display_name
    #is_user_defined = var.alert_policy_is_user_defined
    #state = var.alert_policy_state
    #time_created_greater_than_or_equal_to = var.alert_policy_time_created_greater_than_or_equal_to
    #time_created_less_than = var.alert_policy_time_created_less_than
    #type = var.alert_policy_type
}

locals {
  fail_login_alert_policy_id = tolist([for each in data.oci_data_safe_alert_policies.test_alert_policies.alert_policy_collection[0].items : each.id if each.display_name == "Failed Logins by Admin User"])
  user_mod_alert_policy_id = tolist([for each in data.oci_data_safe_alert_policies.test_alert_policies.alert_policy_collection[0].items : each.id if each.display_name == "User Creation/Modification"])
}

output "fail_login" {
  value=local.fail_login_alert_policy_id[0]
}


output "user_mod" {
  value=local.user_mod_alert_policy_id[0]
}

resource "oci_data_safe_target_alert_policy_association" "test_target_alert_policy_association" {
  for_each = data.oci_data_safe_alert_policies.test_alert_policies.alert_policy_collection[0].items
  #Required
  compartment_id = var.compartment_ocid
  is_enabled     = true
  policy_id      = each.id
  target_id      = local.ds_target_id

  #Optional
  #description   = var.target_alert_policy_association_description
  #display_name  = var.target_alert_policy_association_display_name
}
