locals {
  environment = "Prod"
}

// set variable to get details of vpc based on it;s
/* variable "vpc_tag" {

} */

// Extract details of vpc based by filtering with tags
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Env"           // Because inside console, There will be tag with key being "Env"
    values = [local.environment] // value of an respective key
  }
}


// SECOND WAY
/* data "aws_vpc" "prod_vpc" {
  tags = {
    Env = "Prod"
  }
} */

// Extract all supported attributes from an remote vpc
output "vpc_all_details" {
  value = data.aws_vpc.selected
}


// AWS availabaility zones data source

data "aws_availability_zones" "available" {
  state = "available"
}

output "azs_names" {
  value = data.aws_availability_zones.available.names[*]  // This is called as splat expression
  // Because, here will be in the form of list and we can extract based on their index considering length of the collection
  // "*" means, extract all the elements from all the indexes from the length of collection
}