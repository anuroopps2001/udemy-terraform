variable "vpc_configuration" {
  type = object({
    cidr_block = string
    name       = string
  })

  validation {
    condition     = can(cidrnetmask(var.vpc_configuration.cidr_block))
    error_message = "The cidr_block config option must contain a valid CIDR block."
  }
}

variable "subnet_configuration" {
  type = map(object({
    cidr_block = string
    public     = optional(bool, false) // By default, create only private subnets
    az         = string
  }))

  validation {
    condition = alltrue([
      for config in values(var.subnet_configuration) : can(cidrnetmask(config.cidr_block))
    ])
    error_message = "The cidr_block config option must contain a valid CIDR block."
  }

}