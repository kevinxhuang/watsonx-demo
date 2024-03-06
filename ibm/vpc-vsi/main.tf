provider "ibm" {
  region = var.region
}

data "ibm_resource_group" "rg" {
  count = var.resource_group == "Default" ? 0 : 1
  name  = var.resource_group
}

data "ibm_is_image" "image" {
  name = var.vpc_vsi_image_name
}

data "ibm_is_security_group" "default-sg" {
  name       = "${var.vpc}-default-sg"
  depends_on = [ibm_is_vpc.vpc]
}

data "ibm_is_ssh_key" "keys" {
  for_each = toset([for key in var.keys : tostring(key)])
  name     = each.value
}

locals {
  keys = [
    for key in data.ibm_is_ssh_key.keys : key.id
  ]
}

resource "ibm_is_vpc" "vpc" {
  name                        = var.vpc
  resource_group              = var.resource_group == "Default" ? null : data.ibm_resource_group.rg[0].id
  default_security_group_name = "${var.vpc}-default-sg"
  default_routing_table_name  = "${var.vpc}-default-rt"
  default_network_acl_name    = "${var.vpc}-default-na"
}

resource "ibm_is_subnet" "subnet" {
  name                     = "${var.vpc}-${var.zone}-sn"
  total_ipv4_address_count = 64
  resource_group           = var.resource_group == "Default" ? null : data.ibm_resource_group.rg[0].id
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = var.zone
}

resource "ibm_is_security_group_rule" "inbound-rule-icmp" {
  group     = data.ibm_is_security_group.default-sg.id
  direction = "inbound"
  icmp {
    type = 8
    code = 0
  }
}

resource "ibm_is_security_group_rule" "inbound-rule-ssh" {
  group     = data.ibm_is_security_group.default-sg.id
  direction = "inbound"
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "outbound-rule-dns-udp" {
  group     = data.ibm_is_security_group.default-sg.id
  direction = "outbound"
  udp {
    port_min = 53
    port_max = 53
  }
}

resource "ibm_is_security_group_rule" "outbound-rule-dns-tcp" {
  group     = data.ibm_is_security_group.default-sg.id
  direction = "outbound"
  tcp {
    port_min = 53
    port_max = 53
  }
}

resource "ibm_is_security_group_rule" "outbound-rule-http" {
  group     = data.ibm_is_security_group.default-sg.id
  direction = "outbound"
  tcp {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_security_group_rule" "outbound-rule-https" {
  group     = data.ibm_is_security_group.default-sg.id
  direction = "outbound"
  tcp {
    port_min = 443
    port_max = 443
  }
}

resource "ibm_is_instance" "vsi" {
  name           = "${var.vpc}-vsi"
  resource_group = var.resource_group == "Default" ? null : data.ibm_resource_group.rg[0].id
  vpc            = ibm_is_vpc.vpc.id
  zone           = var.zone
  image          = data.ibm_is_image.image.id
  profile        = var.vpc_vsi_profile_name
  keys           = local.keys[*]

  boot_volume {
    name = "${var.vpc}-vsi-boot-volume"
    size = 250
  }

  primary_network_interface {
    name   = "${var.vpc}-vsi-primary-interface"
    subnet = ibm_is_subnet.subnet.id
    security_groups = [
      data.ibm_is_security_group.default-sg.id
    ]
  }
}

resource "ibm_is_floating_ip" "vsi-fip" {
  name           = "${var.vpc}-vsi-fip"
  resource_group = var.resource_group == "Default" ? null : data.ibm_resource_group.rg[0].id
  target         = ibm_is_instance.vsi.primary_network_interface[0].id
  depends_on     = [ibm_is_instance.vsi]
}
