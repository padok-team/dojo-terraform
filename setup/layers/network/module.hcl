terraform {
  source = "${get_repo_root()}/setup/modules//network"
}

locals {
  root = read_terragrunt_config(find_in_parent_folders())
  name = local.root.locals.project
}

inputs = {
  context = {
    vpc_cidr               = "10.0.0.0/16"
    vpc_single_nat_gateway = true
    vpc_name               = local.name
    vpc_availability_zone  = ["eu-west-3a", "eu-west-3b"]
    vpc_single_nat_gateway = false
  }
}
