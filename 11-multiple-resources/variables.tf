variable "subnet_count" {
  default     = 2
  type        = number
  description = "Number of subnets for this VPC"
}

variable "instance_count" {
  type        = number
  description = "Number of ec2 instances to be created"
}

variable "ec2_instance_config_list" {
  type = list(object(
    {
      instance_type = string
      ami           = string
      subnet_name   = optional(string, "default")
    }
  ))
  validation {
    condition = alltrue([ // all true expects list of all values to be "true"
      for cfg in var.ec2_instance_config_list : contains(["t2.micro"], cfg.instance_type)
    ])
    error_message = "instance_type must be t2.micro only"
  }
  validation {
    condition = alltrue([
      for image_type in var.ec2_instance_config_list : contains(["ubuntu", "nginx"], image_type.ami)
    ])
    error_message = "At least one of the provided \"ami\" values is not supported.\nSupported \"ami\" values: \"ubuntu\", \"nginx\"."
  }
}

variable "ec2_instance_config_map" {
  type = map(object({
    instance_type = string
    ami           = string
    subnet_index  = optional(number, 0)
    subnet_name   = optional(string, "default")
  }))
  # Two way to iterate over map and to create an list

  # METHOD: 1
  validation {
    condition = alltrue([for value in values(var.ec2_instance_config_map) : contains(["ubuntu", "nginx"], value.ami)
    ])
    error_message = "At least one of provided \"ami\" value is not supported.\nSupported \"ami\" values: \"ubuntu\", \"nginx\"."
  }

  # METHOD: 2 Here, values function will return values of an map in the list and we iterate over
  validation {
    condition     = alltrue([for _, value in var.ec2_instance_config_map : contains(["t2.micro"], value.instance_type)])
    error_message = "instance_type must be t2.micro only"
  }

}

variable "subnet_map" {
  type = map(object({
    cidr_block = string
  }))

  validation {
    condition     = alltrue([for _, sub_net_value in var.subnet_map : can(cidrnetmask(sub_net_value.cidr_block))])
    error_message = "At least one of the provided CIDR blocks is not valid."
  }
}