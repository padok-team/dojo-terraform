resource "aws_iam_user" "these" {
  for_each      = toset(var.context.vm.github_usernames)
  name          = each.value
  path          = "/"
  force_destroy = true
}

resource "aws_iam_access_key" "these" {
  for_each = toset(var.context.vm.github_usernames)
  user     = each.value

  depends_on = [
    aws_iam_user.these
  ]
}

# TODO: find accurate rights for Dojo needs
data "aws_iam_policy_document" "admin" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "admin" {
  for_each = toset(var.context.vm.github_usernames)
  name     = "AdministratorAccess"
  user     = each.value
  policy   = data.aws_iam_policy_document.admin.json

  depends_on = [
    aws_iam_user.these
  ]
}
