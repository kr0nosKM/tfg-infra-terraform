#-- ROUTER --#
resource "openstack_networking_router_v2" "r_general" {
  name           = "r_general"
  admin_state_up = "true"
}

resource "openstack_networking_router_interface_v2" "r_int_web" {
  router_id = openstack_networking_router_v2.r_general.id
  subnet_id = openstack_networking_subnet_v2.s_web.id
}

resource "openstack_networking_router_interface_v2" "r_int_bbdd" {
  router_id = openstack_networking_router_v2.r_general.id
  subnet_id = openstack_networking_subnet_v2.s_bbdd.id
}

#-- REDES --#
resource "openstack_networking_network_v2" "n_pub" {
  name           = "n_pub"
  admin_state_up = true
  external = true
  #segment = .....network_type = "flat"
}

resource "openstack_networking_network_v2" "n_web" {
  name           = "n_web"
  admin_state_up = true
  
}

resource "openstack_networking_network_v2" "n_bbdd"{
  name           = "n_bbdd"
  admin_state_up = true
}

#-- SUBREDES --#
resource "openstack_networking_subnet_v2" "s_pub" {
  network_id       = openstack_networking_network_v2.n_pub.id
  cidr             = "172.24.4.0/24"
  ip_version       = 4
  gateway_ip       = "172.24.4.1"
  enable_dhcp      = false

  allocation_pool {
    start = "172.24.4.10"
    end   = "172.24.4.200"
  }
}

resource "openstack_networking_subnet_v2" "s_web" {
  name            = "s_web"
  network_id      = openstack_networking_network_v2.n_web.id
  cidr            = "10.0.0.0/24"
  ip_version      = 4
  enable_dhcp = false
 #gateway_ip      = "10.0.0.1/24"

}

resource "openstack_networking_subnet_v2" "s_bbdd" {
  name            = "s_bbdd"
  network_id      = openstack_networking_network_v2.n_bbdd.id
  cidr            = "10.1.0.0/24"
  ip_version      = 4
  #gateway_ip      = "10.1.0.1/24"

}

#- PUERTOS -#
resource "openstack_networking_port_v2" "p_web_priv" {
  name           = "p_web_priv"
  network_id     = openstack_networking_network_v2.n_web.id
  admin_state_up = "true"
  fixed_ip{
    subnet_id = openstack_networking_subnet_v2.s_web.id
  }
}

# IP Flotante
resource "openstack_networking_port_v2" "p_web_pub" {
  name           = "p_web_pub"
  network_id     = openstack_networking_network_v2.n_pub.id
  admin_state_up = "true"
  fixed_ip{
    subnet_id = openstack_networking_subnet_v2.s_pub.id
  }
}