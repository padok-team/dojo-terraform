resource "aws_iam_user" "user" {
  name          = "user"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "user" {
  user                    = aws_iam_user.user.name
  password_length         = 20
  password_reset_required = false
}

resource "aws_iam_user_policy_attachment" "user" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
