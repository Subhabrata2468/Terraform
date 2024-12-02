terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.75.1"
    }
  }
  backend "s3" {
    bucket         = "trial-bucket-1129312763638267012337224"
    key            = "terraform.tfstate"
    region         = "us-east-2"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

resource "aws_instance" "myec2" {
    ami = "ami-0453ec754f44f9a4a"
    instance_type = "t2.nano"

    tags = {
        Name = "Myec2"
    }
}  