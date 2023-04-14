output "public_ip_per_user" {
  description = "Public IP address of the VM per user, which can be used to create DNS records."
  value       = { for user in var.context.vm.github_usernames : user => aws_instance.this[user].public_ip }
}

output "ssh_command_per_user" {
  description = "SSH command to connect to the VM per user, using the public IP DNS record."
  value       = { for user in var.context.vm.github_usernames : user => "ssh ${user}@${aws_route53_record.these[user].fqdn}" }
}

output "admin_user" {
  description = "Admin user credentials"
  value = {
    name     = aws_iam_user.admin.name
    password = aws_iam_user_login_profile.admin.password
  }
}

# output "ecr_repository_urls" {
#   description = "List of ecrs respository urls."
#   value       = module.ecr.ecr_repository_urls
# }
