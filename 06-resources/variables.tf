variable "availability_zone" {
  type        = string
  description = "Az for the subnet"
}

variable "instance_type" {
  type = string
  description = "Instance type for ec2"
}
variable "env" {
  type = string
  description = "Variable defines the environment in which terraform configuration will be deployed"
}

# to test how terraform works without assgning value to the variable
# variable "testing_var" {}