output "bucket_name" {
  description = "Name of the created S3 bucket."
  value       = aws_s3_bucket.my_bucket.bucket
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket."
  value       = aws_s3_bucket.my_bucket.arn
}

output "bucket_region" {
  description = "AWS region of the created S3 bucket."
  value       = aws_s3_bucket.my_bucket.region
}

output "image_key" {
  description = "Key (path) of the uploaded object inside the bucket."
  value       = aws_s3_object.image.key
}
