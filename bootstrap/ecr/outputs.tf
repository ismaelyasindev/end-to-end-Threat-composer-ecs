output "ecr_repository_url" {
  value       = aws_ecr_repository.app.repository_url
  description = "ECR repository URL for docker push/pull"
}

output "ecr_repository_arn" {
  value       = aws_ecr_repository.app.arn
  description = "ECR repository ARN"
}

output "ecr_repository_name" {
  value       = aws_ecr_repository.app.name
  description = "ECR repository name"
}
