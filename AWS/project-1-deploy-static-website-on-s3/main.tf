provider "aws" {
  # Configuration options
  region = var.aws_region
}

resource "random_id" "rand_id" {
  byte_length = 8
}

resource "aws_s3_bucket" "S3_bucket" {
  bucket = "bucket-${random_id.rand_id.dec}"
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.S3_bucket.id
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style_css" {
  bucket = aws_s3_bucket.S3_bucket.id
  key    = "style.css"
  source = "style.css"
  content_type = "text/css"
}

resource "aws_s3_object" "script_js" {
  bucket = aws_s3_bucket.S3_bucket.id
  key    = "script.js"
  source = "script.js"
  content_type = "text/javascript"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.S3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.S3_bucket.id
  policy = jsonencode(
    {
        Version = "2012-10-17",
        Statement = [
            {
                Sid = "PublicReadGetObject",
                Effect = "Allow",
                Principal = "*",
                Action = "s3:GetObject",
                Resource = "arn:aws:s3:::${aws_s3_bucket.S3_bucket.id}/*"
            }
        ]
    }
  )
}

resource "aws_s3_bucket_website_configuration" "site_hosting" {
  bucket = aws_s3_bucket.S3_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.S3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

