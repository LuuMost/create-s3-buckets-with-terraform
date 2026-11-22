variable "bucket_name" {
  description = "Globally unique S3 bucket name (3-63 chars, lowercase letters, numbers, dots, hyphens)."
  type        = string
  default     = "nextwork-unique-bucket-lutendo-21"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be 3-63 chars, lowercase letters/numbers/dots/hyphens only."
  }
}

variable "aws_region" {
  description = "AWS region for the bucket. Original project: eu-north-1 (Stockholm)."
  type        = string
  default     = "eu-north-1"
}

variable "project_tag" {
  description = "Value of the 'project' tag applied to the bucket."
  type        = string
  default     = "Create an S3 Bucket with Terraform"
}
