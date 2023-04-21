output "public_subnets" {
  description = "The public subnets deployed in the VPC."
  value       = module.vpc.public_subnets_ids
}

output "private_subnets" {
  description = "The private subnets deployed in the VPC."
  value       = module.vpc.private_subnets_ids
}

output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}
