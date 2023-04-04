terraform {
  source = "${get_repo_root()}/setup/modules//vm"
}

locals {
  root = read_terragrunt_config(find_in_parent_folders())
  name = local.root.locals.project
}

dependency "network" {
  config_path = "${local.root.locals.root_dir}/network"
}

inputs = {
  context = {
    network = {
      vpc_id             = dependency.network.outputs.vpc_id
      public_subnets_ids = dependency.network.outputs.public_subnets
    }
    vm = object({
      name = local.name
      github_usernames = [
        "qprichard"
      ]
      instance_type = "t3a.large"
      repositories  = []
    })
  }
}
