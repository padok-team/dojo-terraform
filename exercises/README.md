# Dojo Terraform

In this dojo, you will learn Terraform basics, how to use the language and how to organize your codebase to make it easly understandable and maintanable.

All along the exercies, we will deploy a basic Frontend / Backend Website exposed on internet with every required AWS infrastructure configurations to make it work.

In order to make it simplier for you, we already set up some parts of the infrastructure and you have a dedicated Virtual Machine with all the tools and rights you need.

Don't hesitate to:
- Read every technical comments
- Inspect provided documentations
- Ask questions

**Target Infrastructure**

![target scheme](./.src/scheme.png)

---

## Usefull documentation

This documentation could be useful for the dojo. Don't be afraid to ask questions and search on internet too.

- [Terraform documentation](https://www.terraform.io/)
- [Tfswitch](https://tfswitch.warrensbox.com/Install/)
- [AWS Terraform provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Slides](../.src/%5BPadok%20x%20XXXX%5D%20Dojo%20Terraform.pdf)

## Step 0 - I set up my toolbox

We will configure your computer to easly connect to the remote Virtual Machine deployed for you, through `Remote-SSH` plugin in VSCode.

**Technical Comments**

*Github configuration:*
- You need a `GitHub account` and an `ssh client`
- Get your github `handle` (username)
- Make sure you declared your `ssh rsa public key` in your github account

If not:
- Run the following commands (on Linux)
```bash
# Create a key pair
ssh-keygen -t rsa -d 4096 -C "your.name@email.com"

# show your public key
cat ~/.ssh/id_rsa.pub

# Copy the value
```
- Follow [the doc](https://docs.github.com/fr/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) to add your public key to github


*IDE configuration:*
- Download & install [Visual Studio Code](https://code.visualstudio.com/download)
- Install [`Remote - SSH`](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension for VSCode
- Use plugin to connect to VM through `<github_handle>@<github_handle>.dojo.padok.school`

*Remote VM configuration (from VSCode remote-ssh):*
- Run The following commands:
```bash
# Go to ~/dojo-terraform
cd ~/dojo-terraform

# Install required terraform version
tfswitch

# Reload .profile configuration
source ~/.profile

# Check terraform is installed
terraform --version
```

*Access to your AWS Console:*
- Go to [AWS Management console](https://aws.amazon.com/fr/console/)
- Click on Sign in
- Connect as IAM User
- In `~/data.txt` find
  - `aws_account_id`
  - `iam_user_name`
  - `iam_user_password`
- You are reader on the Account! Feel free to explore!


<br>

**Acceptance Criterias**

- [ ] I have [Visual Studio Code](https://code.visualstudio.com/) installed with Remote - SSH extension installed
- [ ] I can connect to my remote VM at `<github_handle>@<github_handle>.dojo.padok.school`
- [ ] I can open the repository [dojo-terraform](https://github.com/padok-team/dojo-terraform) on VS Code
- [ ] I can show my installed terraform version
- [ ] I can connect to my AWS Console


Know that you are all set up,you are ready to deploy your application with Terraform on an AWS infrastructure!

<br/>

<details>
  <summary> What did you learn? </summary>
  <ul>
    <li>Use tfswitch to change your terraform version</li>
    <li>Terraform CLI can be used in your console</li>
  </ul>
</details>

<br>

## Step 1 - I Have DNS records for my application

In this exercise, you will deploy a DNS record to make a public endpoint for your future web application.
We will have two endpoints:
- `<github_handle>-frontend.dojo.padok.school`
- `<github_handle>-backend.dojo.padok.school`

In the meantime you will learn how to make a basic configuration for terraform.

<br/>

### A - I can deploy a terraform resource

**Technical Comments**

*Provder configuration:*
- In [`app/`](./app), create a `_settings.tf` file
- Based on [AWS provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs), configure `terraform` and `provider` blocks with
  - `>= 4.0.0` required provider version
  - `eu-west-3` region
  - `default_tags`
    - ManagedByTF = "true"
    - User = "<github_handle>"

*DNS:*
- Create a `dns.tf` file and use [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) resource
- Some useful informations:
  - name - value is like `<github_handle>-app.dojo.padok.school` (for now we juste have one *app* instead of two *frontend* and *backend*)
  - zone_id - value can be found in `~/data.txt`
  - records - value is a `list` you want to put the lb_dns_name that is in `~/data.txt`
  - type - value is `CNAME`

*Deployment:*
- Using your `terraform` CLI in VSCode console and based on [Terraform documentation](https://developer.hashicorp.com/terraform)
- Init your terraform configuration using `terraform init`
- You should see on you terminal "Terraform has been successfully innitialized!"
- Deploy your configuration
- See your DNS record in AWS Console in Route 53 > Hosted zones - `dojo.padok.school`
- Take a look at the `.tfstate` file created on your `app` folder

<br/>

<details>
  <summary> Hint n°1</summary>
  Have you seen the `Use Provider` toggle on the documentation?
</details>

<details>
  <summary> Hint n°2</summary>
  Have you take a look at the aws_route53_record resource documentation? It seems like some parameters are required...
</details>

<details>
  <summary> Hint n°3</summary>
  Maybe try a `terraform init`, `terraform plan`, `terraform apply` commands?
</details>

<br/>

**Acceptance Criterias**
- [ ] I have a DNS record `<github_handle>-app.dojo.padok.school` in my DNS Hosted Zone
- [ ] I can make a `terraform apply` on my `app` folder
- [ ] I have a local terraform `state` with all my deployed resources described in it

<br/>

At this point, your `terraform` configuration is set and you can deploy new resources and change existing ones. But some informations are hardcoded in your code, what do you think of that?

<br/>

### B - I keep my codebase DRY

**Technical Comments**

*Data:*
- Based on [AWS provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest), use a [aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) data to refer an existing hosted zone named `dojo.padok.school`. The route is not private.
- Do the same for an `aws_lb` resource named `padok-dojo-lb` to get the `dns_name` of the load balancer.
- Refer those data in your record resource. The attributes `zone_id` and `records` of your route 53 record should not be hardcoded anymore, but should use data references.

<br/>

<details>
  <summary> Hint n°1</summary>
  Be careful! `resources` and `data` are not the same but they are refered with the same name!
</details>

<details>
  <summary> Hint n°2</summary>
  Resources & Data blocks expose some attributes you can use.
</details>

<br/>

*Locals:*

- Create a new file `locals.tf` and check [how locals are declared in terraform](https://developer.hashicorp.com/terraform/language/values/locals)
- Add a new local `applications` that is a map of empty object named "frontend" and "backend"
- Iterate on this map to create two distinct records
  - `<github_handle>-frontend.dojo.padok.school`
  - `<github_handle>-backend.dojo.padok.school`
- Re-deploy your infrastructure. Your Terraform plan will destroy some resources, that's not a problem.
- Run `terraform state list` command to list every resources deployed in your state, and observe how your iterated resources are organized

<br/>

<details>
  <summary> Hint n°3</summary>
  Have you look at [terraform types](https://developer.hashicorp.com/terraform/language/expressions/types)?
</details>

<details>
  <summary> Hint n°4</summary>
  To iterate over maps, you can use the [for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each) expression.
</details>

<br/>

**Acceptance Criterias**
- [ ] My terraform code does not have external resources hardecoded configuration
- [ ] I have two DNS records for
  - `<github_handle>-frontend.dojo.padok.school`
  - `<github_handle>-backend.dojo.padok.school`
  and the code for these resources is unique

<br/>

At this point, you deployed two dns records for your application, each one pointing on the same Elastic Load Balancer instance.
Now let's deploy our web application! :D

<br/>

<details>
  <summary> What did you learn? </summary>
  <ul>
    <li>Configure a terraform provider</li>
    <li>Deploy a resource</li>
    <li>Destroy a resource</li>
    <li>Use data to get remote resoures informations</li>
    <li>Use locals to avoid repetition in code</li>
    <li>Iterate on your resources</li>
    <li>List resources present in terraform state</li>
  </ul>
</details>

<br/>

## Step 2 - I deploy my application

### A - My load balancer can target my instances

<br/>

We want to configure our Load Balancer to target our application instances, based on their endpoint.

<br/>

**Technical Comments**

*LB target groups*

- Based on the [official documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) and the following template
- Set the accurate configuration to deploy two `aws_lb_target_group` using iteration
- Frontend application runs on port 80 and backend on port 3000
- Useful informations are in `~/data.txt`
- Deploy your resources



```yaml
resource "aws_lb_target_group" "this" {
  # TODO: iterate to create 2 target groups
  name        = "<github-handle>-<app>" #TOFILL
  port        = ""                      #TOFILL
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "" #TOFILL

  health_check {
    enabled             = true
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}
```

<details>
  <summary> Hint n°1</summary>
  You may re-use the  application local already declared.
</details>



<br/>

*LB listener rules:*
- Based on the [official documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) and the following template
- Set the accurate configuration to deploy two `aws_lb_listener_rule` using iteration
- Useful informations are in `~/data.txt`
- Deploy your resources

```yaml
resource "aws_lb_listener_rule" "this" {
  # TODO: iterate to create 2 listener rules
  listener_arn = "" #TOFILL
  action {
    type             = "forward"
    target_group_arn = "" #TOFILL
  }
  condition {
    host_header {
      values = [<my-endpoint-value>] #TOFILL
    }
  }

  lifecycle {
    ignore_changes = [
      priority
    ]
  }
}
```

<br/>

<details>
  <summary> Hint n°1</summary>
  You may re-use the  application local already declared.
</details>

<details>
  <summary> Hint n°2</summary>
  You want to refer the previously created target_group in your resource. A `terraform state list` may help you...
</details>


<details>
  <summary> Hint n°2</summary>
  Feel free to update your existing codebase to avoid code repetition
</details>

<br/>

**Acceptance Criterias**
- [ ] I have a target group for my backend and my frontend
- [ ] My load balancer has new listener rules pointing on the right target groups

<br/>

### B - I use a module to deploy resources

**Technical Comments**

- Use [official documentation](https://developer.hashicorp.com/terraform/language/modules/syntax) to get familiar with the usage of a module
- Take a look at the service module in [`modules/service`](modules/service)
- Some Environment variables must be set
  - frontend: BACKEND_URL
  - backend: APPLICATION_USER - (that's you!)
- Instanciate the module by creating a terraform file in [`app/`](./app). The source can be a relative path to your module.
- You need to deploy two services: `<github-handle>-frontend` and `<github-handle>-backend`
- The ECS cluster name is `padok-dojo`
- Set the proper variables for your module
- Useful informations are in `~/data.txt`
- Deploy your resources

<br/>

<details>
  <summary> Hint n°1</summary>
  You may use a data to get ECS cluster details. Its name is padok-dojo.
</details>

<details>
  <summary> Hint n°2</summary>
  We want to enable lb variable and to fill it...
</details>

<details>
  <summary> Hint n°3</summary>
  You might need some outputs from previously created resources to use for the module variables.
</details>

<details>
  <summary> Hint n°4</summary>
  You can re-use the locals created previously to iterate over the module and create the two services.
</details>

<br/>

**Acceptance Criterias**
- [ ] My backend endpoint shows the expected data
- [ ] My frontend endpoints shows a terraform image and congratulates me for my great work 🥳

<br/>

### C - I have my own module for my application

You built a layer for your application in `app/` folder. But how would you duplicate your deployment for multiple applications?
Let's create a module!

**Technical Comments:**
- First of all, destroy your infrastructure with `terraform destroy`
- Based on [official documentation](https://developer.hashicorp.com/terraform/language/modules), create a module in `modules/app` folder
- We want to create a module able to deploy one container on one endpoint with its specific configurations.
- Re-use the resources you previously deployed
- Set your variables and outputs
- Use your module in `app` folder to deploy your frontend and your backend


<details>
  <summary> Hint n°1</summary>
  You may take as example the service module.
</details>

<details>
  <summary> Hint n°2</summary>
  Avoid declaring data directly in the module. Prefer using variables and declare datas where you call your module.
</details>

<details>
  <summary> Hint n°3</summary>
  Don't forget to keep your code DRY!
</details>


**Acceptance Criterias:**
- [ ] I have an `app` module
- [ ] I use my `app` module in my layer
- [ ] I can easly scale up my number of applications instances with multiple configurations

<br/>

Congratulations!! 🥳 You are a Terraform Builder!

<br/>

<details>
  <summary> What did you learn? </summary>
  <ul>
    <li>Use complexe resources</li>
    <li>Use resource outputs</li>
    <li>Use an existing module</li>
    <li>Destroy your terraform infrastructure</li>
    <li>Create a module</li>
    <li>Create variables</li>
  </ul>
</details>

<br/>

## Step 3 - To go further

### A - Terraform CLI

**Technical Comments:**
- Based on [Terraform CLI documentation](https://developer.hashicorp.com/terraform/cli) and using Treraform CLI
- List all resources of your state
- Remove a resource from your state and make a plan to see what it will do. You can try to apply to see what happens
- Import the resource you deleted in your state
- Destroy only one resource with a `--target`

**Acceptance Criterias:**
- [ ] I know some deeper `terraform CLI`

<br/>

### B - Limitations

**Technical Comments:**
- Take a look at [remote state documentation](https://developer.hashicorp.com/terraform/language/state/remote)
- Take a look at [terragrunt documentation](https://terragrunt.gruntwork.io/)
- Take a look at [Padok team terraform guidelines](https://padok-team.github.io/docs-terraform-guidelines/)

**Acceptance Criterias:**
- [ ] I know why remote state and state lock are necessary
- [ ] I understand the limitations of Terraform and know the usefulness of Terragrunt
- [ ] I have read Padok terraform guidelines

<br/>

## Clean

Don't forget to clean your toolbox by running `terraform destroy` in `exercices/app`. It may take a while...
