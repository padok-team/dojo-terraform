variable "base_name" {
  description = "A base name for ecr"
  type        = string
}

variable "repository_read_access_arns" {
  description = "List of role arns which can read repository"
  type        = list(string)
}
