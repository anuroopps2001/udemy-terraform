// Extract in-built managed policies
data "aws_iam_policy" "managed_policies" {
  for_each = toset(local.role_policies_pair[*].policy)
  arn      = "arn:aws:iam::aws:policy/${each.value}"
}

// attaching policy to the role
resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  for_each   = local.role_policy_map
  role       = aws_iam_role.roles[each.value.role].name
  policy_arn = data.aws_iam_policy.managed_policies[each.value.policy].arn
}