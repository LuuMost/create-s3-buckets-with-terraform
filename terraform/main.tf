# Create S3 Buckets with Terraform
# Original project: NextWork — "Create S3 Buckets with Terraform"
# Author: Richard Lutendo Mudau
#
# This file follows the original project structure (provider -> bucket ->
# public-access block -> uploaded object), with versioning + encryption
# added as a recommended extension. See README.md for the full walkthrough.

terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ---------------------------------------------------------------------------
# 1. AWS provider — tells Terraform which AWS region to work in.
#    Original project used eu-north-1 (Europe / Stockholm).
# ---------------------------------------------------------------------------
provider "aws" {
  region = var.aws_region
}

# ---------------------------------------------------------------------------
# 2. S3 bucket — a container for objects (files) in Amazon S3.
#    The bucket name must be GLOBALLY unique across all AWS accounts.
#    If you get a "BucketAlreadyExists" error, add a long random suffix.
# ---------------------------------------------------------------------------
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name # e.g. "nextwork-unique-bucket-lutendo-21"

  # Tags let you identify the project in the S3 console (Tags panel).
  tags = {
    project = var.project_tag # "Create an S3 Bucket with Terraform"
  }
}

# ---------------------------------------------------------------------------
# 3. Block ALL public access — the bucket is private by default.
#    This is the permission block from the original project.
# ---------------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "my_bucket_public_access_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# ---------------------------------------------------------------------------
# 4. EXTENSION (recommended): versioning + default encryption.
#    Not in the original 3-block version, but best practice for any
#    real bucket: recover from accidental deletes and encrypt at rest.
# ---------------------------------------------------------------------------
resource "aws_s3_bucket_versioning" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ---------------------------------------------------------------------------
# 5. Upload an object — the project extension from the PDF.
#    Uploads image.png from this folder straight into the bucket root
#    (no subfolder). The etag makes Terraform detect file changes.
#    Replace terraform/image.png with your own image if you like.
# ---------------------------------------------------------------------------
resource "aws_s3_object" "image" {
  bucket = aws_s3_bucket.my_bucket.id # Reference the bucket ID
  key    = "image.png"                # Path in the bucket (root, no folder)
  source = "${path.module}/image.png" # Local file path

  etag = filemd5("${path.module}/image.png")
}
