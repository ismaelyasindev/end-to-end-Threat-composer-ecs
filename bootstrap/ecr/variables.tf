variable "aws_region" {
  type        = string
  description = "AWS region for ECR"
  default     = "eu-west-2"
}

variable "repository_name" {
  type        = string
  description = "ECR repository name (e.g. github_org_repo, lowercase, underscores)"
  default     = "ismaelyasindev_end-to-end-threat-composer-ecs"
}
