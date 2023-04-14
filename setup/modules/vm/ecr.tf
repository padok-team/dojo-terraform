# module "ecr" {
#   source = "../ecr"

#   base_name                   = var.context.vm.name
#   repository_read_access_arns = [aws_iam_role.this.arn]
# }
