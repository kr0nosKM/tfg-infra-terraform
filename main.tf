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
  tenant_name = "admin"
  password    = "openstack"
  auth_url    = "http://192.168.56.2/identity"
  project_domain_name = "default"
  region      = "RegionOne"
}
