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
  password    = "pwd"
  auth_url    = "http://192.168.56.2/identity"
  project_domain_name = "default"
  region      = "RegionOne"
}

data "openstack_identity_project_v3" "admin"{
  name = "admin"
}

/*
#-- CREACIÓN DE UN NUEVO PROYECTO --#
resource "openstack_identity_project_v3" "tfg_project" {
  name        = "tfg_project"
  description = "Projecto de final de ciclo"
  enabled     = true
}

# new user

resource "openstack_identity_user_v3" "miguel" {
  default_project_id = openstack_identity_project_v3.tfg_project.id
  name               = "miguel"
  description        = "Usuario para gestionar el projecto de final de ciclo"
  password = "1234"
}

# Assign the user to the project with a member role
resource "openstack_identity_role_assignment_v3" "r_miguel_assign" {
  provider   = openstack
  user_id = openstack_identity_user_v3.miguel.id
  project_id = openstack_identity_project_v3.tfg_project.id
  role_id    = "admin"  # Ensure this role exists in your OpenStack environment
}

#-- CONEXIÓN AL PROVEEDOR OPENSTACK CON EL CORRECTO PROJECTO --#
provider "openstack" {
  alias       = "tfg_project"
  user_id     = openstack_identity_user_v3.miguel.id
  tenant_name = openstack_identity_project_v3.tfg_project.name
  password    = "1234"
  auth_url    = "http://192.168.56.2/identity"
  project_domain_name = "default"
  region      = "RegionOne"
}
*/

#-- GENERACIÓN DE LA CLAVE ASIMÉTRICA --#
resource "openstack_compute_keypair_v2" "kp_instances" {
  name = "kp_instances"
}