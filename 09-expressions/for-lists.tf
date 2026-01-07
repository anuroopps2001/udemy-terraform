locals {
  # To generate a map, we use {} 
  # To generate a list, we use []

  # Perform for loop action on objects inside the list and result will be stored inside the list again
  product      = [for num in var.numbers_list : num * 2]
  even_numbers = [for num in var.numbers_list : num if num % 2 == 0]
  first_names  = [for person in var.people : person.firstname]
  last_names   = [for person in var.people : person.lastname]                          # result will be in the form of list
  full_names   = [for person in var.people : "${person.firstname} ${person.lastname}"] # concatination
}


output "product_output" {
  value = local.product
}
output "even_numbers_list" {
  value = local.even_numbers
}
output "first_names_list" {
  value = local.first_names
}
output "last_names_list" {
  value = local.last_names
}

output "full_names_list" {
  value = local.full_names
}
