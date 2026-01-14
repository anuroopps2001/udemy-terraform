locals {
  roles_policies_map = {
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
}


// This is an Trust Policy
data "aws_iam_policy_document" "iam_policy_document" { // It only answers: who is allowed to assume the role?
  statement {
    actions = ["sts:AssumeRole"] // mandatory for role assumption

    principals { // who can assume the role
      type        = "AWS"
      identifiers = ["arn:aws:iam::785818313570:user/jane"] // The IAM user jane is allowed to assume this role.
    }
  }
}

resource "aws_iam_role" "roles" {
  for_each = local.roles_policies_map
  name     = each.key

  /*   It expands to:
Jane can assume role readonly
Jane can assume role developer
Jane can assume role auditor
Jane can assume role admin */
  assume_role_policy = data.aws_iam_policy_document.iam_policy_document.json // The IAM user jane is allowed to assume 
  // each IAM role whose name is each.key.


}