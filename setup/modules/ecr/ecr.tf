locals {
  ecrs_names = toset(["backend", "frontend"])
}

data "aws_region" "current" {}


module "ecrs" {
  for_each = local.ecrs_names

  source  = "terraform-aws-modules/ecr/aws"
  version = "1.5.1"

  repository_force_delete       = true
  repository_image_scan_on_push = true
  repository_name               = "${var.base_name}/${each.value}"

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

resource "null_resource" "these" {
  for_each = local.ecrs_names
  provisioner "local-exec" {
    command = <<-EOT
      aws ecr get-login-password --region ${data.aws_region.current.name} --profile ${var.profile_name} | docker login --username AWS --password-stdin ${module.ecrs[each.value].repository_url}
      docker build -t ${module.ecrs[each.value].repository_url}:latest -f ${path.module}/docker/${each.value}/Dockerfile ${path.module}/docker/${each.value}/
      docker push ${module.ecrs[each.value].repository_url}:latest
    EOT
  }

  lifecycle {
    ignore_changes = [
      id
    ]
  }
}
