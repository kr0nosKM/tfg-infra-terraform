#- GRUPOS DE SEGURIDAD -#

# WEB
resource "openstack_networking_secgroup_v2" "sg_web" {
  name        = "sg_web"
}

resource "openstack_networking_secgroup_rule_v2" "sg_web_rule_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_web.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_web_rule_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_web.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_web_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_web.id
}
## Debugging
resource "openstack_networking_secgroup_rule_v2" "sg_web_rule_icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  security_group_id = openstack_networking_secgroup_v2.sg_web.id
  remote_ip_prefix  = "0.0.0.0/0"
}


# BBDD
resource "openstack_networking_secgroup_v2" "sg_bbdd" {
  name        = "sg_bbdd"
}

resource "openstack_networking_secgroup_rule_v2" "sg_bbdd_rule_mysql" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3306
  port_range_max    = 3306
  remote_ip_prefix  = "10.0.0.0/24"
  security_group_id = openstack_networking_secgroup_v2.sg_bbdd.id
}


# ANSIBLE MSTR
resource "openstack_networking_secgroup_v2" "sg_mstr" {
  name        = "sg_mstr"
}

resource "openstack_networking_secgroup_rule_v2" "sg_mstr_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg_mstr.id
}