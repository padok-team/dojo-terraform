# Dojo terraform setup

## Requirements

Install the following tools:
- [direnv](https://direnv.net/docs/installation.html)
- [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [tfswitch](https://tfswitch.warrensbox.com/Install/)
- [tgswitch](https://tgswitch.warrensbox.com/)

Be assure you have following roles on AWS accounts:
- padok - *PadokSSO*
- padok_lab - *AdministratorAccess*
- padok_dojo - *AdministratorAccess*

If not, You can ask to the padok aws team.
## Installation

1. In `setup/layers/vm/module.hcl`, set `github_usernames` parameter with accurate list of users.

2. Run the following commands.
```bash
# From repository root folder
tfswitch
tgswitch

cd ./setup/layers

# Allow direnv to use .envrc
direnv allow

# Login to AWS through Padok SSO
aws sso login

terragrunt run-all apply
```

## Infrastructure details

This repository will deploy an AWS infrastructure designed for the Dojo in `padok_dojo` account.
The principal resources deployed are:
- A VPC
- A Route 53 hosted zone `dojo.padok.school`
- An ECS Cluster with an Elastic Load balancer
- Two ECR for backend and frontend application
- A tunned virtual machine for each student with every cli and tools they will need
