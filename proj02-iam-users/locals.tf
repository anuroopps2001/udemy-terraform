locals {
  users = yamldecode(file("${path.module}/users-roles.yaml")).iam_users

  // It will store username as key & username and roles as its attributes at values
  iam_users_map = {
    for u in local.users :
    u.username => u
  }


  // username at keys and roles at values
  users_map = {
    for user_config in local.users : user_config.username => user_config.roles
  }


  // map with roles being stored as keys and policies are stored as values
  role_policies_map = {
    readonly = [
      "ReadOnlyAccess"
    ]

    developer = [
      "AmazonEC2FullAccess",
      "AmazonRDSFullAccess",
      "AmazonVPCFullAccess"
    ]

    auditor = [
      "SecurityAudit"
    ]

    admin = [
      "AdministratorAccess"
    ]
  }


  // flatten takes a list containing nested lists and transforms it into a single, 
  // one-dimensional list by merging all the inner elements 
  role_policies_pair = flatten([
    for role, policies in local.role_policies_map : [
      for policy in policies : {
        role   = role
        policy = policy
      }
    ]
  ])


  // map with roles and its policies are being stored at values for for_each loops
  role_policy_map = {
    for rp in local.role_policies_pair :
    "${rp.role}-${rp.policy}" => rp
  }
}
