variable "aws_region" {
  type        = string
  description = "AWS region for S3 and DynamoDB"
  default     = "eu-west-2"
}

variable "s3_bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name for Terraform state"
}

variable "dynamodb_table_name" {
  type        = string
  description = "DynamoDB table name for Terraform state locking"
  default     = "terraform-state-lock"
}
