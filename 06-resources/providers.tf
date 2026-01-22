provider "aws" {
  # Configuration options
  region = "us-east-2"
  // we can also define the default tags here, inside the provider block based on the user requirements
}

provider "tls" {

}

provider "local" {

}