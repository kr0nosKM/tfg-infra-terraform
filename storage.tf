resource "openstack_blockstorage_volume_v3" "v_web_userFiles" {
  region      = "RegionOne"
  name        = "v_web_userFiles"
  description = "Volumen para los datos de los usuarios"
  size        = 5
}