locals {
  // Map to hold rolename as key and policies at values
  roles_policies_map = {
    readonly = [
      "ReadOnlyAccess"
    ]

// Single role, need multiple policies 
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

// Since, we cannot attach multiple policies to the same role at the same time, we are mapping each policy with 
// each role we want to assign that policy

/* [
  { role="readonly",  policy="ReadOnlyAccess" },
  { role="developer", policy="AmazonEC2FullAccess" },
  { role="developer", policy="AmazonRDSFullAccess" },
  { role="developer", policy="AmazonVPCFullAccess" },
  { role="auditor",   policy="SecurityAudit" },
  { role="admin",     policy="AdministratorAccess" }
] */

  role_policies_list = flatten([
    for role, policies in local.roles_policies_map : [
      for policy in policies : {
        role   = role,
        policy = policy
      }
    ]
  ])


  // If your goal is to extract only the values from a map, Terraform already gives you a built-in function for that:
  // SYNTAX: values(map)
  /* unique_polices = toset(flatten(values(local.iam_users_map))) */

  // values := Extracts only the values from the map:
  /*  [
  ["ReadOnlyAccess"],
  ["AmazonEC2FullAccess", "AmazonRDSFullAccess", "AmazonVPCFullAccess"],
  ["SecurityAudit"],
  ["AdministratorAccess"]
] */


  // flatten = Flattens nested lists into one list:
  /* [
  "ReadOnlyAccess",
  "AmazonEC2FullAccess",
  "AmazonRDSFullAccess",
  "AmazonVPCFullAccess",
  "SecurityAudit",
  "AdministratorAccess"
] */

  // toset := Removes duplicates automatically and convert into set of strings
  /* {
  "ReadOnlyAccess",
  "AmazonEC2FullAccess",
  "AmazonRDSFullAccess",
  "AmazonVPCFullAccess",
  "SecurityAudit",
  "AdministratorAccess"
} */

  // uniqute_policies_set = toset(flatten([for v in values(local.roles_policies_map): v])) // This is only for getting policies as set(strings)
 


 // Converting list into map allowing terraform to loop
 /* "developer-AmazonEC2FullAccess" → { role="developer", policy="AmazonEC2FullAccess" }
    "admin-AdministratorAccess"    → { role="admin", policy="AdministratorAccess" }
     ... 
 */

  roles_policy_map = {
    for rp in local.role_policies_list :
    "${rp.role}-${rp.policy}" => rp
  }

}

// Creating roles from the map, where role name is stored at key
resource "aws_iam_role" "roles" {
  for_each = local.roles_policies_map
  /* 
     readonly
     developer
     auditor
     admin 
  */
  name     = each.key

  /*   It expands to:
Jane can assume role readonly
Jane can assume role developer
Jane can assume role auditor
Jane can assume role admin */
  assume_role_policy = data.aws_iam_policy_document.iam_policy_document.json // The IAM user jane is allowed to assume 
  // each IAM role whose name is each.key.


}
  

// This is an Trust Policy & Defines who can assume the role.
data "aws_iam_policy_document" "iam_policy_document" { // It only answers: who is allowed to assume the role?
  statement {
    actions = ["sts:AssumeRole"] // mandatory for role assumption

    principals { // who can assume the role
      type        = "AWS"
      identifiers = ["arn:aws:iam::785818313570:user/jane"] // The IAM user jane is allowed to assume this role.
    }
  }

}

resource "aws_iam_role_policy_attachment" "name" {
  for_each = local.roles_policy_map
  role = aws_iam_role.roles[each.value.role].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.policy}"
}

// Controls Which roles Jane is allowed to assume.
data "aws_iam_policy_document" "jane-assume_roles" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    resources = [
      aws_iam_role.roles["readonly"].arn,
      aws_iam_role.roles["developer"].arn
    ]
  }
}