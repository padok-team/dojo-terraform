module "ecr" {
  source = "../ecr"

  base_name    = var.context.vm.name
  profile_name = var.context.profile
}
