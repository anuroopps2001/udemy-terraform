variable "ec2_instance_type" {
  type        = string
  description = "The size of managed ec2 instance"

  validation {
    error_message = "Only t2.micro and t3.micro allowed to use"
    // condition     = var.ec2_instance_type == "t2.micro" || var.ec2_instance_type == "t3.micro"

    condition = contains(["t2.micro", "t3.micro"], var.ec2_instance_type) // contains is golang function, 
    // which takes 2 args and checks the condition
  }
}

variable "ec2_volume_config" {
  type = object({
    size = number
    type = string
  })

  default = {
    size = 5
    type = "gp2"
  }
}

variable "additional_tags" {
  type = map(string) // Empty map of strings
  // also, this ensures that key can be of any type, however the value must be of type string always
}