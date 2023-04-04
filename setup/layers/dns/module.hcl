terraform {
  source = "${get_repo_root()}/setup/modules//dns"
}

locals {
  root = read_terragrunt_config(find_in_parent_folders())

  root_zone_name = "padok.school"
  domain_name    = "${local.root.locals.environment}.${local.root_zone_name}"
}

inputs = {
  context = {
    dns = {
      domain_name    = local.domain_name
      root_zone_name = local.root_zone_name
    }
  }
}
