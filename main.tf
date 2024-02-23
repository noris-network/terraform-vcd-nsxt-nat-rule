data "vcd_vdc_group" "vdc_group" {
  name = var.vdc_group_name
}

data "vcd_nsxt_edgegateway" "nsxt_edgegateway" {
  org      = var.vdc_org_name
  owner_id = data.vcd_vdc_group.vdc_group.id
  name     = var.vdc_edgegateway_name
}

data "vcd_nsxt_app_port_profile" "nsxt_app_port_profile" {
  count = var.app_port_profile != null ? 1 : 0
  name  = var.app_port_profile["name"]
  scope = try(var.app_port_profile["scope"], "SYSTEM")
}

resource "vcd_nsxt_nat_rule" "nsxt_nat_rule" {
  org                      = var.vdc_org_name
  edge_gateway_id          = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
  name                     = var.name
  description              = var.description
  enabled                  = var.enabled
  rule_type                = var.rule_type
  external_address         = var.external_address
  internal_address         = var.internal_address
  app_port_profile_id      = try(data.vcd_nsxt_app_port_profile.nsxt_app_port_profile[0].id, null)
  dnat_external_port       = var.dnat_external_port
  snat_destination_address = var.snat_destination_address
  logging                  = var.logging
  firewall_match           = var.firewall_match
  priority                 = var.priority
}
