locals {
  ecrs = ["backend", "frontend"]
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "ecrs" {
  for_each = toset(local.ecrs)

  source  = "terraform-aws-modules/ecr/aws"
  version = "1.5.1"

  repository_image_scan_on_push = true
  repository_name               = "${var.base_name}/${each.value}"
  repository_read_access_arns   = var.repository_read_access_arns

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 2,
        description  = "Remove untagged images after 30 days",
        selection = {
          tagStatus   = "untagged",
          countType   = "sinceImagePushed",
          countUnit   = "days",
          countNumber = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com
resource "null_resource" "this" {
  provisioner "local-exec" {
    command = <<-EOT
      exec "aws ecr get-login-password --region ${aws_region.current.name} | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com"
      exec "command2"
    EOT
  }
}
