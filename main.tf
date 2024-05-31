#-- DEFINICIÓN DEL PROVEEDOR --#
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
    }
  }
}

#-- CONEXIÓN AL PROVEEDOR OPENSTACK --#
provider "openstack" {
  user_name   = "admin"
  tenant_name = "tfg_project"
  password    = "pwd"
  auth_url    = "http://192.168.56.2/identity"
  project_domain_name = "default"
  region      = "RegionOne"
}

#-- GENERACIÓN DE LA CLAVE ASIMÉTRICA --#
resource "openstack_compute_keypair_v2" "kp_instances" {
  name = "kp_instances"
}