locals {
  applications = {
    frontend = {
      port = 80
      env = {
        "BACKEND_URL" = "https://${local.github_handle}-backend.${local.zone_name}"
      }
      image = "450568479740.dkr.ecr.eu-west-3.amazonaws.com/padok-dojo/frontend"
    }
    backend = {
      port = 3000
      env = {
        "APPLICATION_USER" = "emma"
      }
      image = "450568479740.dkr.ecr.eu-west-3.amazonaws.com/padok-dojo/backend"
    }
  }
  github_handle = "edix9"
  zone_name     = "dojo.padok.school"
  vpc_id        = "vpc-059701eb2d3c4d83b"
}
