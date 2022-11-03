
resource "oci_core_vcn" "test_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "demoVCN"
  dns_label      = "demovcn"
}

resource "oci_core_subnet" "test_subnet" {
  cidr_block     = "10.0.1.0/24"
  display_name   = "demoSubnet"
  dns_label      = "demosubnet"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.test_vcn.id
  route_table_id = oci_core_route_table.test_route_table.id
  prohibit_public_ip_on_vnic = (var.autonomous_database_visibility == "Private") ? true : false
}

resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "internet-gateway"
  vcn_id         = oci_core_vcn.test_vcn.id
}

resource "oci_core_service_gateway" "test_service_gateway" {
  count = var.use_only_always_free_eligible_resources ? 0 : 1
  compartment_id = var.compartment_ocid
  display_name   = "service-gateway"
  vcn_id         = oci_core_vcn.test_vcn.id
  services {
    service_id = lookup(data.oci_core_services.all_services.services[0], "id")
  }

}

resource "oci_core_route_table" "test_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.test_vcn.id
  display_name   = "demoRT"

  dynamic "route_rules" {
    for_each = (var.autonomous_database_visibility == "Private") ? [1] : []
    content {
      destination       = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
      destination_type  = "SERVICE_CIDR_BLOCK"
      network_entity_id = oci_core_service_gateway.test_service_gateway.id
    }
  }

  dynamic "route_rules" {
    for_each = (var.autonomous_database_visibility == "Private") ? [] : [1]
    content {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
    }
  }

}

resource "oci_core_network_security_group" "atp_nsg" {
  compartment_id = var.compartment_ocid
  display_name   = "atp_nsg"
  vcn_id         = oci_core_vcn.test_vcn.id

  count = (var.autonomous_database_visibility == "Private") ? 1 : 0
}
resource "oci_core_network_security_group_security_rule" "atp_nsg_rule_1" {
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.atp_nsg[0].id
  protocol                  = "all"
  source                    = oci_core_vcn.test_vcn.cidr_block
  source_type               = "CIDR_BLOCK"

  count = (var.autonomous_database_visibility == "Private") ? 1 : 0
}
resource "oci_core_network_security_group_security_rule" "atp_nsg_rule_2" {
  destination               = oci_core_vcn.test_vcn.cidr_block
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.atp_nsg[0].id
  protocol                  = "all"
  source_type               = ""

  count = (var.autonomous_database_visibility == "Private") ? 1 : 0
}

output "vcn_id" {
  value=oci_core_vcn.test_vcn.id
}
output "subnet_id" {
  value=oci_core_subnet.test_subnet.id
}
