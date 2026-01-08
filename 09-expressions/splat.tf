locals {
  # This is called splat expression, i,e using [*] or [index_value] to access an object 
  splat_from_list = local.map_to_list[*].role
  # Splat expressions only work for lists and not for maps

  // splat_from_maps = local.list_to_map[*].role # Here, we are trying splat expression on an map and it will thrown an error

  role_splat_from_maps = values(local.list_to_map)[0].role # using values() function, we can use splat expression 
}

output "from_splat" {
  value = local.splat_from_list
}

output "role_splat_from_maps" {
  value = local.role_splat_from_maps
}