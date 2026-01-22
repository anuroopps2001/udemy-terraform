output "passwords" {
  value = {
    for user, user_details in aws_iam_user_login_profile.users_passwords : 
    user => user_details.password
  }
  sensitive = true
}