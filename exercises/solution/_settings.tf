#######################################################
#                Provider configuration
#           You can't use locals and vars here
#######################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"

  default_tags {
    tags = {
      ManagedByTF = "True"
      User        = "dummy-user"
    }
  }
}
