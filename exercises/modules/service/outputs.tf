output "task_role" {
  description = "The ECS task role."
  value = {
    name = aws_iam_role.this.name,
    arn  = aws_iam_role.this.arn
  }
}

output "security_group_id" {
  description = "The id of the service security group."
  value       = aws_security_group.service.id
}
