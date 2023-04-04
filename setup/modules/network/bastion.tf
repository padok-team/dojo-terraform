# SSM Bastion to connect to EKS trough an SSH tunnel
module "ssm_bastion" {
  source = "git@github.com:padok-team/terraform-aws-bastion-ssm.git?ref=v4.0.0"

  vpc_zone_identifier = module.vpc.private_subnets_ids
}
