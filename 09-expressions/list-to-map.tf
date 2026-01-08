locals {
  # Creating a map using list of objects
  list_to_map = {
    # for user_info in var.users : user_info.name =>  user_info.role

    # <key>  => <value>  --> MAP SYNTAX
    for u in var.users : u.name => u # Use the user's name as the key, and store all data of that user under that key.
    // When converting a list to a map, you must choose a key that uniquely identifies each element,
    // and no two elements may produce the same key.
  }

  map_to_list = [for user in local.list_to_map : user]

}

output "users_map" {
  value = local.list_to_map
}

output "users_list" {
  value = local.map_to_list
}