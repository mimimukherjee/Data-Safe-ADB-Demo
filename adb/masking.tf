// Copyright (c) 2017, 2021, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0


locals {
  masking_policy_access_level = "ACCESSIBLE"
  masking_policy_column_source_column_source = "TARGET"
  masking_policy_compartment_id_in_subtree = true
}


resource "oci_data_safe_masking_policy" "test_masking_policy" {
  #Required
  column_source {
    #Required
    column_source = "SENSITIVE_DATA_MODEL"

    #Optional
    sensitive_data_model_id = oci_data_safe_sensitive_data_model.test_sensitive_data_model.id
    target_id               = local.ds_target_id[0]
  }
  compartment_id = var.compartment_ocid

  #Optional
  #description                 = var.masking_policy_description
  #display_name                = var.masking_policy_display_name
}


resource "null_resource" "masking_tasks" {
    depends_on = [ oci_data_safe_masking_policy.test_masking_policy, null_resource.grant_data_masking_role ]
    provisioner "local-exec" {
        command = "sh ${path.module}/script/data_masking.sh ${oci_data_safe_masking_policy.test_masking_policy.id} ${local.ds_target_id[0]}"
    }
}

data "oci_data_safe_masking_policies" "test_masking_policies" {
  depends_on = [ null_resource.masking_tasks ]
  #Required
  compartment_id = var.compartment_ocid

  #Optional
  #access_level                          = local.masking_policy_access_level
  #compartment_id_in_subtree             = local.masking_policy_compartment_id_in_subtree
  #display_name                          = var.masking_policy_display_name
  #state                                 = var.masking_policy_state
  #time_created_less_than                = var.masking_policy_time_created_less_than
}


data "oci_data_safe_masking_policies_masking_columns" "test_masking_policies_masking_columns" {
  depends_on = [ null_resource.masking_tasks ]
  #Required
  masking_policy_id = oci_data_safe_masking_policy.test_masking_policy.id
}

