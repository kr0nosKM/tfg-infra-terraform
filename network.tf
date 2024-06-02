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

# resource "openstack_networking_router_interface_v2" "r_int_pub" {
#   router_id = openstack_networking_router_v2.r_general.id
#   subnet_id = openstack_networking_subnet_v2.s_pub.id
  
# }
/*
resource "openstack_networking_subnet_route_v2" "subnet_route_1" {
  subnet_id        = openstack_networking_subnet_v2.s_web.id
  destination_cidr = openstack_networking_subnet_v2.s_pub.cidr
  next_hop         = openstack_networking_subnet_v2.s_pub.gateway_ip
}
*/


#-- REDES --#

data "openstack_networking_network_v2" "public" {
  name = "public"
}


# resource "openstack_networking_network_v2" "n_pub" {
#   name           = "n_pub"
#   admin_state_up = true
#   external = true
#   segments {
#     network_type = "flat"
#     #sphysical_network = external
#   }
# }

resource "openstack_networking_network_v2" "n_web" {
  name           = "n_web"
  admin_state_up = true
}

resource "openstack_networking_network_v2" "n_bbdd"{
  name           = "n_bbdd"
  admin_state_up = true
}

#-- SUBREDES --#
# resource "openstack_networking_subnet_v2" "s_pub" {
#   name            = "s_pub"
#   network_id       = openstack_networking_network_v2.n_pub.id
#   cidr             = "172.30.8.0/24"
#   ip_version       = 4
#   gateway_ip       = "172.30.8.1"
#   enable_dhcp      = false

#   allocation_pool {
#     start = "172.30.8.10"
#     end   = "172.30.8.200"
#   }
# }

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

# # Puerto IP Flotante
# resource "openstack_networking_port_v2" "p_web_pub" {
#   name           = "p_web_pub"
#   network_id     = openstack_networking_network_v2.n_pub.id
#   admin_state_up = "true"
#   fixed_ip{
#     subnet_id = openstack_networking_subnet_v2.s_pub.id
#   }
# }

# Puerto IP Flotante
# resource "openstack_networking_port_v2" "p_web_pub" {
#   name           = "p_web_pub"
#   network_id     = openstack_networking_network_v2.n_web.id
#   admin_state_up = "true"
#   fixed_ip{
#     subnet_id = openstack_networking_subnet_v2.s_web.id
#   }
# }