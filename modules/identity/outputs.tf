output "execution_role_arn" {
  value       = aws_iam_role.execution.arn
  description = "ARN of the ECS Execution Role"
}