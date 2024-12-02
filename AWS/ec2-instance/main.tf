terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.75.1"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}

resource "aws_instance" "myec2" {
    ami = var.ami
    instance_type = "t2.nano"

    tags = {
        Name = "Myec2"
    }
}  