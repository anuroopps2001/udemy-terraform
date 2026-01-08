locals {
  name      = "Travis Head"
  age       = 33
  abs_value = -23
  my_object = {
    key1 = 10
    key2 = "my_value"
  }
}

output "example01" {
  value = upper(local.name)
}
output "example02" {
  value = lower(local.name)
}

output "example03" {
  value = startswith(lower(local.name), "john")
}

output "example04" {
  value = abs(local.age)
}

output "example05" {
  value = abs(local.abs_value)
}
output "example06" {
  value = pow(local.abs_value, 2)
}

output "example07" {
  value = file("${path.module}/users.yaml")
}
output "example08" {
  value = yamldecode(file("${path.module}/users.yaml")).users
}
output "example09" {
  value = yamldecode(file("${path.module}/users.yaml")).users[1] // Splat expressions
}

output "example10" {
  value = yamldecode(file("${path.module}/users.yaml")).users[*].name
}

output "example11" {
  value = yamlencode(local.my_object) // we can also use jsonencode
}