// Copyright (c) 2017, 2021, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0


data "oci_data_safe_data_safe_configuration" "test_data_safe_configuration" {
  compartment_id = var.tenancy_ocid
}

resource "oci_data_safe_data_safe_configuration" "test_data_safe_configuration" {
  count = data.oci_data_safe_data_safe_configuration.test_data_safe_configuration != null ? ( data.oci_data_safe_data_safe_configuration.test_data_safe_configuration.is_enabled != "true" ? 1 : 0 ) : 0 
  is_enabled = "true"
  compartment_id = var.tenancy_ocid
}

resource "oci_data_safe_data_safe_private_endpoint" "test_data_safe_private_endpoint" {
  count = (var.autonomous_database_visibility == "Private") ? 1 : 0
  compartment_id = var.compartment_ocid
  display_name   = "PE2"
  subnet_id      = module.vcn[0].subnet_id
  vcn_id         = module.vcn[0].vcn_id
}

data "oci_data_safe_audit_profile_analytic" "test_audit_profile_analytic" {
  #Required
  compartment_id = var.tenancy_ocid

  #Optional
  #group_by                  = var.audit_profile_analytic_group_by
}

