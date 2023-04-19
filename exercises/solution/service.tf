data "aws_ecs_cluster" "ecs" {
  cluster_name = "padok-dojo"
}

module "services" {
  source   = "../modules/service"
  for_each = local.applications

  cluster = {
    id   = data.aws_ecs_cluster.ecs.id
    name = data.aws_ecs_cluster.ecs.cluster_name
  }

  config = {
    name        = "${local.github_handle}-${each.key}"
    image       = each.value.image
    port        = each.value.port
    environment = each.value.env
  }

  vpc_id = local.vpc_id
  private_subnets_ids = [
    "subnet-0c7f1321b93ca8798",
    "subnet-00e7fcd5e985a1ea1",
  ]

  lb = {
    enabled           = true
    target_group_arn  = aws_lb_target_group.this[each.key].arn
    security_group_id = "sg-05cdc024f70fc171d"
  }

}
