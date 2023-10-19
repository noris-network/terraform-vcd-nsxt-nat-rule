# terraform-vcd-nsxt-nat-rule

Terraform module which manages NSX-T NAT-Rule ressources on VMWare Cloud Director.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.9 |
| <a name="requirement_vcd"></a> [vcd](#requirement\_vcd) | >= 3.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vcd"></a> [vcd](#provider\_vcd) | 3.9.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vcd_nsxt_nat_rule.nsxt_nat_rule](https://registry.terraform.io/providers/vmware/vcd/latest/docs/resources/nsxt_nat_rule) | resource |
| [vcd_nsxt_edgegateway.nsxt_edgegateway](https://registry.terraform.io/providers/vmware/vcd/latest/docs/data-sources/nsxt_edgegateway) | data source |
| [vcd_vdc_group.vdc_group](https://registry.terraform.io/providers/vmware/vcd/latest/docs/data-sources/vdc_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | A name for the NAT rule. | `string` | n/a | yes |
| <a name="input_rule_type"></a> [rule\_type](#input\_rule\_type) | One of DNAT, NO\_DNAT, SNAT, NO\_SNAT, REFLEXIVE | `string` | n/a | yes |
| <a name="input_vdc_edgegateway_name"></a> [vdc\_edgegateway\_name](#input\_vdc\_edgegateway\_name) | The name for the Edge Gateway. | `string` | n/a | yes |
| <a name="input_vdc_group_name"></a> [vdc\_group\_name](#input\_vdc\_group\_name) | The name of the VDC group. | `string` | n/a | yes |
| <a name="input_vdc_org_name"></a> [vdc\_org\_name](#input\_vdc\_org\_name) | The name of the organization to use. | `string` | n/a | yes |
| <a name="input_app_port_profile_id"></a> [app\_port\_profile\_id](#input\_app\_port\_profile\_id) | Application Port Profile to which to apply the rule. The Application Port Profile includes a port, and a protocol that the incoming traffic uses on the edge gateway to connect to the internal network. Can be looked up using vcd\_nsxt\_app\_port\_profile data source or created using vcd\_nsxt\_app\_port\_profile resource. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | A description for the NAT rule. | `string` | `null` | no |
| <a name="input_dnat_external_port"></a> [dnat\_external\_port](#input\_dnat\_external\_port) | For DNAT only. This represents the external port number or port range when doing DNAT port forwarding from external to internal. The default dnatExternalPort is “ANY” meaning traffic on any port for the given IPs selected will be translated. | `number` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enables or disables the NAT rule. | `bool` | `true` | no |
| <a name="input_external_address"></a> [external\_address](#input\_external\_address) | The external address for the NAT Rule. This must be supplied as a single IP or Network CIDR. For a DNAT rule, this is the external facing IP Address for incoming traffic. For an SNAT rule, this is the external facing IP Address for outgoing traffic. These IPs are typically allocated/suballocated IP Addresses on the Edge Gateway. For a REFLEXIVE rule, these are the external facing IPs. | `string` | `null` | no |
| <a name="input_firewall_match"></a> [firewall\_match](#input\_firewall\_match) | (VCD 10.2.2+) - You can set a firewall match rule to determine how firewall is applied during NAT. One of MATCH\_INTERNAL\_ADDRESS, MATCH\_EXTERNAL\_ADDRESS, BYPASS. | `string` | `"MATCH_INTERNAL_ADDRESS"` | no |
| <a name="input_internal_address"></a> [internal\_address](#input\_internal\_address) | The internal address for the NAT Rule. This must be supplied as a single IP or Network CIDR. For a DNAT rule, this is the internal IP address for incoming traffic. For an SNAT rule, this is the internal IP Address for outgoing traffic. For a REFLEXIVE rule, these are the internal IPs. These IPs are typically the Private IPs that are allocated to workloads. | `string` | `null` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | Enable to have the address translation performed by this rule logged. Note User might lack rights (Organization Administrator role by default is missing Gateway -> Configure System Logging right) to enable logging, but API does not return error and it is not possible to validate it. terraform plan might show difference on every update. | `bool` | `false` | no |
| <a name="input_priority"></a> [priority](#input\_priority) | (VCD 10.2.2+) - if an address has multiple NAT rules, you can assign these rules different priorities to determine the order in which they are applied. A lower value means a higher priority for this rule. | `number` | `0` | no |
| <a name="input_snat_destination_address"></a> [snat\_destination\_address](#input\_snat\_destination\_address) | For SNAT only. The destination addresses to match in the SNAT Rule. This must be supplied as a single IP or Network CIDR. Providing no value for this field results in match with ANY destination network. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the NAT-Rule. |
<!-- END_TF_DOCS -->

## Examples

### Single instance

```
module "nat_rule" {
  source               = "git::https://github.com/noris-network/terraform-vcd-nsxt-nat-rule?ref=1.0.0"
  name                 = "outbound_snat"
  vdc_org_name         = "1-2"
  vdc_group_name       = "1-2-nbg"
  vdc_edgegateway_name = "T1-1-2-nbg"
  rule_type            = "SNAT"
  external_address     = "123.234.123.234"
  internal_address     = "10.0.0.0/8"
}
```

### Real world example

```
locals {
  nat_rules = [
    {
      name             = "outbound_nat"
      rule_type        = "SNAT"
      external_address = "123.234.123.235"
      internal_address = "192.168.0.0/24"
    },
    {
      name             = "no_snat_192.168.0.0/24"
      rule_type        = "NO_SNAT"
      external_address = "192.168.0.0/24"
      internal_address = "192.168.0.0/24"
    }
  ]
}

module "nat_rules" {
  source               = "git::https://github.com/noris-network/terraform-vcd-nsxt-nat-rule?ref=1.0.0"
  for_each             = { for nat_rule in locals.nat_rules : nat_rule.name => nat_rule }
  name                 = "${each.value.name}_${terraform.workspace}"
  vdc_org_name         = var.vdc_org_name
  vdc_edgegateway_name = var.vdc_edge_gateway_name
  vdc_group_name       = var.vdc_group_name
  rule_type            = each.value.rule_type
  external_address     = try(each.value.external_address, null)
  internal_address     = try(each.value.internal_address, null)
}
```
