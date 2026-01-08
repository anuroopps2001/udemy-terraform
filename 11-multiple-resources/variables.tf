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
  }))

}