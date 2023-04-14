resource "aws_iam_user" "admin" {
  name          = "admin"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "admin" {
  user                    = aws_iam_user.admin.name
  password_length         = 20
  password_reset_required = false
}

resource "aws_iam_user_policy_attachment" "admin" {
  user       = aws_iam_user.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
