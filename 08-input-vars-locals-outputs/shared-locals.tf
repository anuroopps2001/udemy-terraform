// local variables can be placed inside the specific configuration file or in separate file like this, which can referenced 
// across all the configuration files in this directory
locals {
  project_name = "08-input-vars-locals-output"
  ManagedBy = "Terraform"
  project_owner = "Aws-Terraform"
}

locals {
  common_tags = {
    project_name = local.project_name
    ManagedBy = local.ManagedBy
    project_owner = local.project_owner
    cost_center = "Bengaluru"
    sensitive_info = var.sensitive_variable
  }
}

