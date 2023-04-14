output "ecr_repository_urls" {
  description = "List of ecr repository urls."
  value       = values(module.ecrs).*.repository_url
}
