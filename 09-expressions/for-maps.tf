locals {
  # To generate a map, we use {} 
  # To generate a list, we use []
  doubles_map      = { for key, value in var.numbers_map : "${key} + ${key}" => value * 2 }
  even_numbers_map = { for key, value in var.numbers_map : key => value * 2 if value % 2 == 0 }
  // Also, in maps, duplicated keys are not allowed and keys must be unique

  // Here, we are iterating over an map and storing the results in the to map using {}
}
output "numbers_map_output" {
  value = local.doubles_map
}

output "even_numbers_map" {
  value = local.even_numbers_map
}