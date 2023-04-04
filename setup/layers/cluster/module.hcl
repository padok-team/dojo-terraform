terraform {
  source = "${get_repo_root()}/setup/modules//ecs/cluster"
}

locals {
  root = read_terragrunt_config(find_in_parent_folders())
  name = "${local.root.locals.project}-${local.root.locals.environment}"
}

dependency "network" {
  config_path = "${local.root.locals.root_dir}/network/${local.root.locals.environment}"
}

dependency "dns" {
  config_path = "${local.root.locals.root_dir}/dns/${local.root.locals.environment}"
}

inputs = {
  context = {
    network = {
      vpc_id             = dependency.network.outputs.vpc_id
      public_subnets_ids = dependency.network.outputs.public_subnets
    }
    dns = {
      acm_certificate_arn = dependency.dns.outputs.acm_certificate_arn
    }
    ecs_cluster = {
      name = local.name
    }
  }
}
