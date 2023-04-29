terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 4.0.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
        region = "eu-west-3"

    default_tags {
        tags = 
            ManagedByTF = "true"
            User = "<blblbly>"

# Configure the route 53
resource "aws_route53_zone" "primary" {
  name = "dojo.padok.school"
}
data "aws_lb" "padok-dojo-lb" {
  name = padok-dojo-lb
}
}
}
