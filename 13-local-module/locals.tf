locals {
  project = "13-local-modules"

  custom_tags = {
    ManagedBy = "terraform"
    Name      = local.project
    project   = local.project
  }
}