include "root" {
  path           = find_in_parent_folders()
  merge_strategy = "deep"
}

include "module" {
  path           = "module.hcl"
  merge_strategy = "deep"
}
