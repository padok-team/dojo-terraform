resource "aws_security_group" "this" {
  name        = var.context.vm.name
  vpc_id      = var.context.network.vpc_id
  description = "Security group for the training VM. All ports are open."

  ingress {
    description = "Allow all Ingress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all Egress"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  tags = var.context.tags
}

data "aws_ami" "ubuntu_20_04" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  # Canonical
  owners = ["099720109477"]
}

locals {
  user_data_per_user = { for user in var.context.vm.github_usernames :
    user => templatefile("${path.module}/templates/userdata.yaml.tpl", {
      github_username = user,
      repositories    = var.context.vm.repositories
      }
    )
  }
}

resource "aws_instance" "this" {
  for_each = toset(var.context.vm.github_usernames)

  vpc_security_group_ids = [aws_security_group.this.id]

  ami                  = data.aws_ami.ubuntu_20_04.id
  instance_type        = var.context.vm.instance_type
  iam_instance_profile = aws_iam_instance_profile.this.name

  #checkov:skip=CKV_AWS_88:The instance needs to be public
  associate_public_ip_address = true
  subnet_id                   = var.context.network.public_subnets_ids[0]

  # Checkov recommandations
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  ebs_optimized = true
  root_block_device {
    encrypted = true
  }
  monitoring = true

  user_data                   = local.user_data_per_user[each.key]
  user_data_replace_on_change = true
  tags = merge(
    { Name = "${var.context.vm.name}-${each.key}" },
    var.context.tags
  )
}


# --- SSM Policies ---

data "aws_iam_policy_document" "ec2_sts_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }

}
resource "aws_iam_role" "this" {
  name_prefix        = var.context.vm.name
  assume_role_policy = data.aws_iam_policy_document.ec2_sts_assume.json
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name_prefix = var.context.vm.name
  role        = aws_iam_role.this.name
}
