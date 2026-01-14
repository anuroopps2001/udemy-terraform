locals {
  users = yamldecode(file("${path.module}/users-roles.yaml"))

  iam_users_map = { for u in local.users.iam_users : u.username => u } // It will store username as key & username and roles as its attributes
}

// Any resource that uses for_each becomes a map of resource instances. So aws_iam_user.users will become an map 
resource "aws_iam_user" "users" {
  for_each = local.iam_users_map
  name     = each.key // Because, username inside the map was stored as key, as explained below
  // john = {
  //   username = john
  //   roles = [readonly, developer]
  // }
}

resource "aws_iam_user_login_profile" "users_passwords" {
  for_each        = aws_iam_user.users
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

output "passwords" {
  value = {
    for user, user_details in aws_iam_user_login_profile.users_passwords : user => user_details.password
  }
  sensitive = true
}
/* output "users" {
  value = local.users
} */