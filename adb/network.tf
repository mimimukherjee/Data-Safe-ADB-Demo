module "vcn" {
  source               = "./modules/vcn"
  compartment_ocid       = var.compartment_ocid
  autonomous_database_visibility = var.autonomous_database_visibility
  use_only_always_free_eligible_resources = var.use_only_always_free_eligible_resources
  count = (var.autonomous_database_visibility == "Private") ? 1 : 0
}
