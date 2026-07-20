output "execution_role_arn" {
  value = aws_iam_role.this.arn
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}