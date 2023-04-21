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

dependency "dns" {
  config_path = "${local.root.locals.root_dir}/dns"
}

dependency "cluster" {
  config_path = "${local.root.locals.root_dir}/cluster"
}

inputs = {
  context = {
    dns = dependency.dns.outputs.this
    network = {
      vpc_id              = dependency.network.outputs.vpc_id
      public_subnets_ids  = dependency.network.outputs.public_subnets
      private_subnets_ids = dependency.network.outputs.private_subnets
    }
    lb = dependency.cluster.outputs.lb
    vm = {
      name             = local.name
      github_usernames = []
      instance_type    = "t3a.large"
      repositories = {
        "dojo-terraform" = "https://github.com/padok-team/dojo-terraform.git"
      }
    }
  }
}
