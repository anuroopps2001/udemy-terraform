provider "aws" {
  # Configuration options
  region = "us-east-1"
}

provider "aws" {
  # Configuration options
  region = "eu-west-1"
  alias = "eu_west"
}