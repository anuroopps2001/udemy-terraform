output "current_region" {
  value = data.aws_region.current
}

output "currnet_user_details" {
  value = data.aws_caller_identity.caller_identity
}