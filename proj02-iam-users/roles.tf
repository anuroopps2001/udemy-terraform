// Get the AWS account ID and other account details
data "aws_caller_identity" "current_account_details" {}

data "aws_iam_policy_document" "assume_role_policy" {
  for_each = toset(keys(local.role_policies_map))
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        for username in keys(aws_iam_user.users) : "arn:aws:iam::${data.aws_caller_identity.current_account_details.account_id}:user/${username}"
        if contains(local.users_map[username], each.value)
      ]
    }
  }
}

resource "aws_iam_role" "roles" {
  for_each           = toset(keys(local.role_policies_map))
  name               = each.key
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[each.value].json
}
