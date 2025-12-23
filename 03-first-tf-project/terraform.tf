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
}

