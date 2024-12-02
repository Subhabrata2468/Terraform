terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.78.0"
    }

    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
  
}