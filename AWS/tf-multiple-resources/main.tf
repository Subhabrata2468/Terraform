terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.75.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "tf_vpc" {
  
}