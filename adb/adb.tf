// Copyright (c) 2017, 2021, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0



resource "random_string" "autonomous_database_admin_password" {
  length      = 16
  min_numeric = 1
  min_lower   = 1
  min_upper   = 1
  min_special = 1
  override_special = "_#-"
}


resource "oci_database_autonomous_database" "test_autonomous_database" {
  #Required
  admin_password           = random_string.autonomous_database_admin_password.result
  compartment_id           = var.compartment_ocid
  cpu_core_count           = var.autonomous_database_cpu_core_count
  data_storage_size_in_tbs = var.autonomous_database_data_storage_size_in_tbs
  db_name                  = var.autonomous_database_name

  #Optional
  #db_version               = var.autonomous_database_db_version
  db_workload              = var.autonomous_database_db_workload
  display_name             = var.autonomous_database_name  
  freeform_tags            = var.autonomous_database_freeform_tags
  is_free_tier             = local.autonomous_database_is_free_tier
  license_model            = var.autonomous_database_license_model
  #is_auto_scaling_enabled  = "true"
  is_preview_version_with_service_terms_accepted = "false"
  #nsg_ids                  = (var.autonomous_database_visibility == "Private") ? [oci_core_network_security_group.atp_nsg[0].id] : []
  #subnet_id                = (var.autonomous_database_visibility == "Private") ? oci_core_subnet.test_subnet.id : ""
  
}

resource "oci_database_autonomous_database_wallet" "test_autonomous_database_wallet" {
    #Required
    autonomous_database_id = oci_database_autonomous_database.test_autonomous_database.id
    password = random_string.autonomous_database_admin_password.result

    #Optional
    base64_encode_content = "true"
    #generate_type = var.autonomous_database_wallet_generate_type
}

resource "local_file" "wallet" {
    content_base64  = oci_database_autonomous_database_wallet.test_autonomous_database_wallet.content
    filename = "${path.module}/wallet.zip"
}

resource "null_resource" "load_adb" {
    depends_on = [ local_file.wallet ]
    provisioner "local-exec" {
        command = "sh ${path.module}/script/load_adb.sh ${path.module} ${oci_database_autonomous_database.test_autonomous_database.db_name} ${oci_database_autonomous_database.test_autonomous_database.admin_password}"
    }
}

resource "null_resource" "target_adb_reg" {
    depends_on = [ null_resource.load_adb ]

    provisioner "local-exec" {
        command = "oci db autonomous-database data-safe register --autonomous-database-id ${oci_database_autonomous_database.test_autonomous_database.id} --pdb-admin-password ${oci_database_autonomous_database.test_autonomous_database.admin_password} --wait-for-state SUCCEEDED "
    }
    provisioner "local-exec" {
        command = "sleep 30"
    }
}

resource "null_resource" "grant_data_masking_role" {
    depends_on = [ local_file.wallet, null_resource.target_adb_reg ]
    provisioner "local-exec" {
        command = "sh ${path.module}/script/grant_data_masking_role.sh ${path.module} ${oci_database_autonomous_database.test_autonomous_database.db_name} ${oci_database_autonomous_database.test_autonomous_database.admin_password}"
    }
}

output "autonomous_database_password" {
  value     = random_string.autonomous_database_admin_password.result
  sensitive = true
}

