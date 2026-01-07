locals {
    # Creating a map using list of objects
  result = {
    for user_info in var.users : user_info.name =>  user_info.role
  }
}

output "users_map" {
  value = local.result
}