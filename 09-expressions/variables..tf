variable "numbers_list" {
  type = list(number)
}

variable "people" {
  type = list(object({
    firstname = string
    lastname  = string
  }))
}

variable "numbers_map" {
  type = map(number) # key can be of any type. However, the value must be of number type only
}

variable "users" {
  type = list(object({
    name = string
    role = string
  }))
}