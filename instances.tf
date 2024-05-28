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
  key_pair        = openstack_compute_keypair_v2.kp_instances.id
  security_groups = [openstack_networking_secgroup_v2.sg_web.id]

  network {
    name = "n_web"
    port = openstack_networking_port_v2.p_web_priv.id
  }
}

resource "openstack_compute_volume_attach_v2" "v_web_userFiles_attached" {
  instance_id = openstack_compute_instance_v2.i_nxtcld.id
  volume_id   = openstack_blockstorage_volume_v3.v_web_userFiles.id
  device = "/dev/user_data"
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