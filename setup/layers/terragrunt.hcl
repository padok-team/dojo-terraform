
terraform_version_constraint  = "~> 1.3"
terragrunt_version_constraint = "~> 0.38"

locals {
  region        = "eu-west-3"
  backup_region = "eu-central-1"
  project       = "padok-school"
  environment   = basename(get_original_terragrunt_dir())
  profile = {
    root = "padok_lab"
    dojo = "padok_dojo"
  }
  env_profile = local.profile[local.environment]
  root_dir    = get_terragrunt_dir()
}

inputs = {
  context = {
    region        = local.region
    backup_region = local.backup_region
    env           = local.environment
    project       = local.project
    # Add default_tags here to manually add tags on resources when provider don't do it for us!
    default_tags = {
      Environment = "${local.environment}"
      Owner       = "${local.project}"
      ManagedByTF = "True"
    }
  }
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "tf-state-${local.project}-${local.region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    dynamodb_table = "terraform-locks"
    profile        = local.env_profile
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"

  default_tags {
    tags = var.context.default_tags
  }

  profile = "${local.env_profile}"
}
provider "aws" {
  region = "${local.region}"

  default_tags {
    tags = var.context.default_tags
  }
  alias = "root"
  profile = "${local.profile["root"]}"
}

provider "aws" {
  region = "${local.backup_region}"
  alias  = "backups"

  default_tags {
    tags = var.context.default_tags
  }

  profile = "${local.env_profile}"
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
