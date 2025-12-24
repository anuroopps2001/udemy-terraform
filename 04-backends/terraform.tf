terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27.0"
    }

    // Random provider is for uniqueness, not security.
    random = { // Used to generate unique, stable values
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    // check out .tfbackend files and use while performing terraform initialization in respective environment

    // terraform init -backend-config="prod.s3.tfbackend"  // To initialize statefile for production environment
  }
}


