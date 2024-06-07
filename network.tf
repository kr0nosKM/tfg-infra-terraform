#-- ROUTER --#
resource "openstack_networking_router_v2" "r_general" {
  name           = "r_general"
  admin_state_up = "true"
  external_network_id = data.openstack_networking_network_v2.public.id
  enable_snat = false
}

resource "openstack_networking_router_interface_v2" "r_int_web" {
  
  router_id = openstack_networking_router_v2.r_general.id
  subnet_id = openstack_networking_subnet_v2.s_web.id
}

resource "openstack_networking_router_interface_v2" "r_int_bbdd" {
  router_id = openstack_networking_router_v2.r_general.id
  subnet_id = openstack_networking_subnet_v2.s_bbdd.id
}

resource "openstack_networking_router_interface_v2" "r_int_mstr" {
  
  router_id = openstack_networking_router_v2.r_general.id
  subnet_id = openstack_networking_subnet_v2.s_web.id
}

resource "openstack_networking_router_route_v2" "r_general_ruta_global" {
  depends_on       = [openstack_networking_router_interface_v2.r_int_web, openstack_networking_router_interface_v2.r_int_bbdd, openstack_networking_router_interface_v2.r_int_mstr]
  router_id        = openstack_networking_router_v2.r_general.id
  destination_cidr = "0.0.0.0/0"
  next_hop         = "172.24.4.1"
}

#-- REDES --#
data "openstack_networking_network_v2" "public" {
  name = "public"
}

resource "openstack_networking_network_v2" "n_web" {
  name           = "n_web"
  admin_state_up = true
}

resource "openstack_networking_network_v2" "n_bbdd"{
  name           = "n_bbdd"
  admin_state_up = true
}

resource "openstack_networking_network_v2" "n_mstr"{
  name           = "n_mstr"
  admin_state_up = true
}

#-- SUBREDES --#
resource "openstack_networking_subnet_v2" "s_web" {
  name            = "s_web"
  network_id      = openstack_networking_network_v2.n_web.id
  cidr            = "10.0.0.0/24"
  ip_version      = 4
  enable_dhcp = true
}

resource "openstack_networking_subnet_v2" "s_bbdd" {
  name            = "s_bbdd"
  network_id      = openstack_networking_network_v2.n_bbdd.id
  cidr            = "10.1.0.0/24"
  ip_version      = 4
}

resource "openstack_networking_subnet_v2" "s_mstr" {
  name            = "s_bbdd"
  network_id      = openstack_networking_network_v2.n_bbdd.id
  cidr            = "10.1.0.0/24"
  ip_version      = 4
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

resource "openstack_networking_port_v2" "p_bbdd_priv" {
  name           = "p_bbdd_priv"
  network_id     = openstack_networking_network_v2.n_bbdd.id
  admin_state_up = "true"
  fixed_ip{
    subnet_id = openstack_networking_subnet_v2.s_bbdd.id
  }
}

resource "openstack_networking_port_v2" "p_mstr_priv" {
  name           = "p_mstr_priv"
  network_id     = openstack_networking_network_v2.n_mstr.id
  admin_state_up = "true"
  fixed_ip{
    subnet_id = openstack_networking_subnet_v2.s_mstr.id
  }
}