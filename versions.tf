terraform {
  required_version = ">= 1.1.9"
  required_providers {
    vcd = {
      source  = "vmware/vcd"
      version = ">= 3.9.0"
    }
  }
}
