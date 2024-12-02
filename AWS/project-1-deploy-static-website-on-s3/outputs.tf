output "aws_s3_bucket" {
  value       = aws_s3_bucket.S3_bucket.id
  description = "The ID of the S3 bucket"
  
}

output "s3_bucket_website_endpoint" {
  value       = aws_s3_bucket.S3_bucket.website_endpoint
  description = "The S3 bucket website endpoint URL"
}
