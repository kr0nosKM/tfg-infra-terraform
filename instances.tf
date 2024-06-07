#-- IMÁGEN DEBIAN --#
resource "openstack_images_image_v2" "debian_12" {
  name             = "debian_12"
  image_source_url = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
  container_format = "bare"
  disk_format      = "qcow2"
}

resource "openstack_images_image_v2" "debian_10" {
  name             = "debian_10"
  image_source_url = "https://cloud.debian.org/images/cloud/bullseye/20240507-1740/debian-11-nocloud-amd64-20240507-1740.qcow2"
  container_format = "bare"
  disk_format      = "qcow2"
}

#-- CARACTERÍSTICAS HARDWARE --#
resource "openstack_compute_flavor_v2" "flv_web" {
  name  = "flv_web"
  ram   = "2048"
  vcpus = "1"
  disk  = "3"
}

resource "openstack_compute_flavor_access_v2" "web" {
  tenant_id = data.openstack_identity_project_v3.admin.id
  flavor_id = openstack_compute_flavor_v2.flv_web.id
}

resource "openstack_compute_flavor_v2" "flv_bbdd" {
  name  = "flv_bbdd"
  ram   = "1024"
  vcpus = "1"
  disk  = "2"
}

resource "openstack_compute_flavor_access_v2" "bbdd" {
  tenant_id = data.openstack_identity_project_v3.admin.id
  flavor_id = openstack_compute_flavor_v2.flv_bbdd.id
}

resource "openstack_compute_flavor_v2" "flv_mstr" {
  name  = "flv_mstr"
  ram   = "1024"
  vcpus = "1"
  disk  = "4"
}

resource "openstack_compute_flavor_access_v2" "mstr" {
  tenant_id = data.openstack_identity_project_v3.admin.id
  flavor_id = openstack_compute_flavor_v2.flv_mstr.id
}

#-- INSTANCIA WEB --#
resource "openstack_compute_instance_v2" "i_nxtcld" {
  name            = "i_nxtcld"
  image_id        = openstack_images_image_v2.debian_10.id
  flavor_id       = openstack_compute_flavor_v2.flv_web.id
  key_pair        = openstack_compute_keypair_v2.kp_instances.id
  security_groups = [openstack_networking_secgroup_v2.sg_web.id]
  admin_pass = "1234"

  network {
    name = "n_web"
    port = openstack_networking_port_v2.p_web_priv.id
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
    apt-get update
    apt-get install -y nginx
  EOF
}

#-- INSTANCIA MySQL --#
resource "openstack_compute_instance_v2" "MySQL" {
  name            = "mysql"
  image_id        = openstack_images_image_v2.debian_10.id
  flavor_id       = openstack_compute_flavor_v2.flv_bbdd.id
  key_pair        = openstack_compute_keypair_v2.kp_instances.id
  security_groups = [openstack_networking_secgroup_v2.sg_bbdd.id]

  network {
    name = "n_bbdd"
    port = openstack_networking_port_v2.p_bbdd_priv.id
  }

  provisioner "local-exec" {
    command = "echo 'local_exec is working' >> test.txt"
  }
}

#-- INSTANCIA MASTER ANSIBLE --#
resource "openstack_compute_instance_v2" "i_mstr" {
  name            = "i_mstr"
  image_id        = openstack_images_image_v2.debian_10.id # Lo ideal sería crear una ami con lo necesario
  flavor_id       = openstack_compute_flavor_v2.flv_mstr.id
  key_pair        = openstack_compute_keypair_v2.kp_mstr.id
  security_groups = [openstack_networking_secgroup_v2.sg_mstr.id]

  network {
    name = "n_web"
    port = openstack_networking_port_v2.p_web_priv.id
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
    apt-get update
    apt-get install -y ansible

  EOF
}

resource "openstack_compute_volume_attach_v2" "v_web_usersFiles_attached" {
  instance_id = openstack_compute_instance_v2.i_nxtcld.id
  volume_id   = openstack_blockstorage_volume_v3.v_web_usersFiles.id
  #device = "/dev/vdb"
}



# IP Flotante asignada a la instáncia web NXTCLD
resource "openstack_networking_floatingip_v2" "fip_web" {
  pool = data.openstack_networking_network_v2.public.name
}

resource "openstack_networking_floatingip_associate_v2" "fip_web_asignacion" {
  port_id = openstack_networking_port_v2.p_web_priv.id
  floating_ip = openstack_networking_floatingip_v2.fip_web.address
}

# IP Flotante asignada a la instáncia mstr Ansible
resource "openstack_networking_floatingip_v2" "fip_mstr" {
  pool = data.openstack_networking_network_v2.public.name
}

resource "openstack_networking_floatingip_associate_v2" "fip_mstr_asignacion" {
  port_id = openstack_networking_port_v2.p_mstr_priv.id
  floating_ip = openstack_networking_floatingip_v2.fip_mstr.address
}