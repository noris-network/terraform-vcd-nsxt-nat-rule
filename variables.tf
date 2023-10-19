variable "vdc_org_name" {
  description = "The name of the organization to use."
  type        = string
}

variable "vdc_group_name" {
  description = "The name of the VDC group."
  type        = string
}

variable "vdc_edgegateway_name" {
  description = "The name for the Edge Gateway."
  type        = string
}

variable "name" {
  description = "A name for the NAT rule."
  type        = string
}

variable "description" {
  description = "A description for the NAT rule."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Enables or disables the NAT rule."
  type        = bool
  default     = true
}

variable "rule_type" {
  description = "One of DNAT, NO_DNAT, SNAT, NO_SNAT, REFLEXIVE"
  type        = string
}

variable "external_address" {
  description = "The external address for the NAT Rule. This must be supplied as a single IP or Network CIDR. For a DNAT rule, this is the external facing IP Address for incoming traffic. For an SNAT rule, this is the external facing IP Address for outgoing traffic. These IPs are typically allocated/suballocated IP Addresses on the Edge Gateway. For a REFLEXIVE rule, these are the external facing IPs."
  type        = string
  default     = null
}

variable "internal_address" {
  description = "The internal address for the NAT Rule. This must be supplied as a single IP or Network CIDR. For a DNAT rule, this is the internal IP address for incoming traffic. For an SNAT rule, this is the internal IP Address for outgoing traffic. For a REFLEXIVE rule, these are the internal IPs. These IPs are typically the Private IPs that are allocated to workloads."
  type        = string
  default     = null
}

variable "app_port_profile_id" {
  description = "Application Port Profile to which to apply the rule. The Application Port Profile includes a port, and a protocol that the incoming traffic uses on the edge gateway to connect to the internal network. Can be looked up using vcd_nsxt_app_port_profile data source or created using vcd_nsxt_app_port_profile resource."
  type        = string
  default     = null
}

variable "dnat_external_port" {
  description = "For DNAT only. This represents the external port number or port range when doing DNAT port forwarding from external to internal. The default dnatExternalPort is “ANY” meaning traffic on any port for the given IPs selected will be translated."
  type        = number
  default     = null
}

variable "snat_destination_address" {
  description = "For SNAT only. The destination addresses to match in the SNAT Rule. This must be supplied as a single IP or Network CIDR. Providing no value for this field results in match with ANY destination network."
  type        = string
  default     = null
}

variable "logging" {
  description = "Enable to have the address translation performed by this rule logged. Note User might lack rights (Organization Administrator role by default is missing Gateway -> Configure System Logging right) to enable logging, but API does not return error and it is not possible to validate it. terraform plan might show difference on every update."
  type        = bool
  default     = false
}

variable "firewall_match" {
  description = "(VCD 10.2.2+) - You can set a firewall match rule to determine how firewall is applied during NAT. One of MATCH_INTERNAL_ADDRESS, MATCH_EXTERNAL_ADDRESS, BYPASS."
  type        = string
  default     = "MATCH_INTERNAL_ADDRESS"
}

variable "priority" {
  description = "(VCD 10.2.2+) - if an address has multiple NAT rules, you can assign these rules different priorities to determine the order in which they are applied. A lower value means a higher priority for this rule."
  type        = number
  default     = 0
}
