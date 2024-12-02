terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.75.1"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}

resource "random_id" "rand_id" {
  byte_length = 10
}

resource "aws_s3_bucket" "demo-bucket" {
  bucket = "trial-bucket-${random_id.rand_id.dec}"
  //force_destroy = true  # Deletes bucket and all its contents
}

resource "aws_s3_object" "bucket-data" {
  bucket = aws_s3_bucket.demo-bucket.bucket
  source = "./mydata.txt"
  key = "introduction-of-project.txt"
}