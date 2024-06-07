resource "openstack_blockstorage_volume_v3" "v_web_userFile" {
  region      = "RegionOne"
  name        = "v_web_userFiles"
  description = "Volumen para los datos de los usuarios"
  size        = 2
}

resource "openstack_blockstorage_volume_v3" "v_web_usersFiles" {
  region      = "RegionOne"
  name        = "vol_web_userFiles"
  description = "Volumen para los datos de los usuarios"
  size        = 2
}