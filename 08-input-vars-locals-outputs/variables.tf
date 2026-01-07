variable "ec2_instance_type" {
  type        = string
  description = "The size of managed ec2 instance"

  validation {
    error_message = "Only t2.micro and t3.micro allowed to use"
    // condition     = var.ec2_instance_type == "t2.micro" || var.ec2_instance_type == "t3.micro"

    # condition = contains(["t2.micro", "t3.micro"], var.ec2_instance_type) // contains is golang function, 
    // which takes 2 args and checks the condition



# TF_VAR_ec2_instance_type = "t3.small" via environment variables and this must start with TF_VAR and variable name Ex;- TF_VAR.ec2_instance_type
# It's set to "t3.medium" in terraform.tfvars
# and, It's set to "t3.micro" in 01-env-auto.tfvars
    condition = startswith(var.ec2_instance_type, "t3")
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

variable "sensitive_variable" {
  sensitive = true
  type = string
}