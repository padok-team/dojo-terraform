resource "aws_ecs_cluster" "this" { # Standard de naming des ressources -> https://github.com/padok-team/docs-terraform-guidelines/blob/main/terraform/terraform_naming.md
  name = var.context.ecs_cluster.name

  tags = {
    CostCenter = "Stargate" # J'ai repris l'exemple de ce qu'il y a dans le module 'network' ici
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}
