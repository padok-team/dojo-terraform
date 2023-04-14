variable "region" {
  description = "The region."
  type        = string
}

variable "cluster" {
  description = "The ECS cluster instance config."
  type = object({
    id   = string
    name = string
  })
}

variable "config" {
  description = "The ECS container configuration."
  type = object({
    name          = string
    image         = string
    port          = number
    cpu           = number
    memory        = number
    desired_count = number
    environment   = optional(map(string), {})
    secrets       = optional(map(string), {})
  })
}

variable "vpc_id" {
  description = "The VPC id."
  type        = string
}

variable "private_subnets_ids" {
  description = "The VPC private subnets ids list."
  type        = list(string)
}

variable "lb" {
  description = "ECS load balancer connexion configuration."
  type = object({
    enabled           = bool
    target_group_arn  = string
    security_group_id = string
  })
  default = {
    enabled           = false
    target_group_arn  = null
    security_group_id = null
  }
}
