terraform {
  required_providers {
    aws = { // Here, we can keep the name whatever we want  and refer the same name below 
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
  }
}

provider "aws" { // specify the provider name if modified here. But this is not recommended
  # Configuration options
  region = "us-east-1"
}


// Same provider with different regions
provider "aws" {
  region = "eu-west-1"
  // This alias name needs to specified when we want to create the resources specifically in that region 
  alias = "eu-west"
}