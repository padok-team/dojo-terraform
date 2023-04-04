locals {

  # Generate CIDRs
  pub_1  = cidrsubnet(var.context["vpc_cidr"], lookup(var.subnets["pub_1"], "newbits"), lookup(var.subnets["pub_1"], "netnum"))
  pub_2  = cidrsubnet(var.context["vpc_cidr"], lookup(var.subnets["pub_2"], "newbits"), lookup(var.subnets["pub_2"], "netnum"))
  priv_1 = cidrsubnet(var.context["vpc_cidr"], lookup(var.subnets["priv_1"], "newbits"), lookup(var.subnets["priv_1"], "netnum"))
  priv_2 = cidrsubnet(var.context["vpc_cidr"], lookup(var.subnets["priv_2"], "newbits"), lookup(var.subnets["priv_2"], "netnum"))
}

module "vpc" {
  source = "git@github.com:padok-team/terraform-aws-network.git?ref=v0.1.1"

  vpc_name              = var.context["vpc_name"]
  vpc_availability_zone = var.context["vpc_availability_zone"]

  vpc_cidr            = var.context["vpc_cidr"]
  public_subnet_cidr  = [local.pub_1, local.pub_2]
  private_subnet_cidr = [local.priv_1, local.priv_2]

  single_nat_gateway = var.context["vpc_single_nat_gateway"]

  tags = {
    CostCenter = "Network"
  }
}

# VPC Endpoints to avoid going through the NAT Gateway for traffic that can be kept internal

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.context["region"]}.s3"
  vpc_endpoint_type = "Interface"

  subnet_ids = module.vpc.private_subnets_ids

  tags = {
    CostCenter = "Network"
  }
}
