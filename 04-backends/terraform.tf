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
    bucket = "terraform-remote-backend-387439"
    key = "04-terraform-backends/state.tfstate"
    // This region need not be same the as the region, where terraform is creating our resources
    region = "us-east-1"
  }
}

