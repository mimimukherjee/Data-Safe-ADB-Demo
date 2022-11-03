// Copyright (c) 2017, 2021, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0

#variable "data_safe_target_ocid" {
  #default = ""
#}


#variable "discovery_job_defined_tags_value" {
  #default = "value"
#}

#variable "discovery_job_discovery_type" {
  #default = "ALL"
#}

#variable "discovery_job_display_name" {
  #default = "displayName"
#}

#variable "discovery_job_freeform_tags" {
  #default = { "Department" = "Finance" }
#}

#variable "discovery_job_is_app_defined_relation_discovery_enabled" {
  #default = false
#}

#variable "discovery_job_is_include_all_schemas" {
  #default = true
#}

#variable "discovery_job_is_include_all_sensitive_types" {
  #default = true
#}

#variable "discovery_job_state" {
  #default = "ACTIVE"
#}

#variable "sensitive_data_model_display_name" {
  #default = "displayName"
#}
#variable "sensitive_data_model_schemas_for_discovery" {
  #default = []
#}

#variable "sensitive_data_model_sensitive_type_ids_for_discovery" {
  #default = []
#}

data "oci_data_safe_target_databases" "test_target_databases" {
  depends_on = [ null_resource.target_adb_reg ]
    #Required
    compartment_id = var.compartment_ocid

    #Optional
    #access_level = var.target_database_access_level
    #associated_resource_id = oci_data_safe_associated_resource.test_associated_resource.id
    #compartment_id_in_subtree = var.target_database_compartment_id_in_subtree
    #database_type = var.target_database_database_type
    #display_name = var.autonomous_database_name
    #infrastructure_type = var.target_database_infrastructure_type
    state = "ACTIVE"
    #target_database_id = oci_data_safe_target_database.test_target_database.id
}

locals {
  ds_target_id = tolist([for each in data.oci_data_safe_target_databases.test_target_databases.target_databases : each.id if each.display_name == var.autonomous_database_name])
}

resource "oci_data_safe_sensitive_data_model" "test_sensitive_data_model" {
  #Required
  compartment_id = var.compartment_ocid
  target_id      = local.ds_target_id[0]

  #Optional
  #display_name                              = var.sensitive_data_model_display_name
  #schemas_for_discovery                     = var.sensitive_data_model_schemas_for_discovery
  #sensitive_type_ids_for_discovery          = var.sensitive_data_model_sensitive_type_ids_for_discovery
  is_app_defined_relation_discovery_enabled = "true"
  is_include_all_schemas = "true"
  is_include_all_sensitive_types = "true"
  is_sample_data_collection_enabled = "true"
}

resource "oci_data_safe_discovery_job" "test_discovery_job" {
  #Required
  compartment_id          = var.compartment_ocid
  sensitive_data_model_id = oci_data_safe_sensitive_data_model.test_sensitive_data_model.id

  #Optional
  #discovery_type                            = var.discovery_job_discovery_type
  #freeform_tags                             = var.discovery_job_freeform_tags
  #is_app_defined_relation_discovery_enabled = var.discovery_job_is_app_defined_relation_discovery_enabled
  #is_include_all_schemas                    = var.discovery_job_is_include_all_schemas
  #is_include_all_sensitive_types            = var.discovery_job_is_include_all_sensitive_types
}

data "oci_data_safe_discovery_jobs" "test_discovery_jobs" {
  #Required
  compartment_id = var.compartment_ocid

  #Optional
  #discovery_job_id          = oci_data_safe_discovery_job.test_discovery_job.id
  #sensitive_data_model_id   = oci_data_safe_sensitive_data_model.test_sensitive_data_model.id
  #state                     = var.discovery_job_state
}

data "oci_data_safe_sensitive_data_models_sensitive_columns" "test_sensitive_data_models_sensitive_columns" {
    #Required
    sensitive_data_model_id = oci_data_safe_sensitive_data_model.test_sensitive_data_model.id
}

