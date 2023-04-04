terraform {
  source = "${get_repo_root()}/setup/modules//network"
}

locals {
  root = read_terragrunt_config(find_in_parent_folders())
  name = "${local.root.locals.project}-${local.root.locals.environment}"
}

inputs = {
  context = {
    vpc_name              = local.name
    vpc_availability_zone = ["eu-west-3a", "eu-west-3b"]

    # By default have a NATGW on each public subnet
    vpc_single_nat_gateway = false
  }
}
