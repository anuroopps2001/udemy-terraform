// Any resource that uses for_each becomes a map of resource instances. So aws_iam_user.users will become an map 
resource "aws_iam_user" "users" {
  for_each = local.iam_users_map
  name     = each.key
}

resource "aws_iam_user_login_profile" "users_passwords" {
  for_each        = aws_iam_user.users // because any resource created with "for_each" becomes a map of resource instances
  user            = each.key
  password_length = 8

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key
    ]
  }

}