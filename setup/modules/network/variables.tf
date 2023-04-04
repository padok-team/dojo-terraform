
variable "context" {
  type = any
}

# Documentation about cidrsubnet() https://www.terraform.io/language/functions/cidrsubnet
# Default values assume that we are using a /16 CIDR vor the VPC
variable "subnets" {
  description = "Parameters to cidrsubnet function to calculate subnet masks within the VPC"
  default = {
    pub_1  = { netnum = 0, newbits = 8 } # => /24
    pub_2  = { netnum = 1, newbits = 8 } # => /24
    priv_1 = { netnum = 2, newbits = 2 } # => /18 (16k IPs)
    priv_2 = { netnum = 3, newbits = 2 } # => /18 (16k IPs)
  }
  type = map(any)
}
