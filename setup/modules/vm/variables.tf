variable "context" {
  type = object({
    tags = map(string)
    network = object({
      vpc_id = string
    })
    vm = object({
      name             = string
      github_usernames = list(string)
      instance_type    = string
      repositories     = map(string)
    })
  })
}
