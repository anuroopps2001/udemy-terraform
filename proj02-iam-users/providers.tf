terraform {
  required_version = "~>1.7"
  required_providers {
    aws = {
      version = "6.27.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}