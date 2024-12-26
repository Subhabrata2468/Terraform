provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc-main" {
  cidr_block = vars.vpc_config.cidr_block
  
  tags = {
    Name = vars.vpc_config.vpc_name
  }
}