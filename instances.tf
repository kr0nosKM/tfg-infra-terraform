#-- IMÁGEN DEBIAN --#
resource "openstack_images_image_v2" "debian_10" {
  name             = "debian_10"
  image_source_url = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
  container_format = "bare"
  disk_format      = "qcow2"
}

#-- INSTANCIA WEB --#
resource "openstack_compute_instance_v2" "i_nxtcld" {
  name            = "i_nxtcld"
  image_id        = openstack_images_image_v2.debian_10.image_id
  flavor_id       = "3"
  key_pair        = "kp"
  security_groups = ["default"]

  network {
    name = "n_web"
    port = openstack_networking_port_v2.p_1.id
  }
}
/*
# IP Flotante asignada a la instáncia web NXTCLD
resource "openstack_networking_floatingip_v2" "fip_web" {
  pool = openstack_networking_network_v2.n_pub.name
}

resource "openstack_networking_floatingip_associate_v2" "fip_web_asignacion" {
  port_id = openstack_networking_port_v2.p_1.id
  floating_ip = openstack_networking_floatingip_v2.fip_web.address
}


#--  --#

*/