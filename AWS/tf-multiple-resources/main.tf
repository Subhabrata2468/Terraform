#required provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.75.1"
    }
  }
}

#provider
provider "aws" {
  region = "us-east-1"
}

#locals variables
locals {
  project_name = "tf_vpc"
}

#creating resource of vpc
resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${local.project_name}"
  }
}

#creating resource of subnets for the vpc
resource "aws_subnet" "tf_vpc_subnet" {
  vpc_id = "${aws_vpc.tf_vpc.id}"
  cidr_block= "10.0.${count.index}.0/24"
  count = 2
  tags = {
    Name = "${local.project_name}-subnet-${count.index}"
  }
}

#creating resources of instances for subnets
resource "aws_instance" "ec2_instance" {
  count = 4
  ami= "ami-0453ec754f44f9a4a"
  instance_type = "t2.micro"
  subnet_id = element(aws_subnet.tf_vpc_subnet[*].id, count.index % length(aws_subnet.tf_vpc_subnet))
  # 0 % 2 = 0
  # 1 % 2 = 1
  # 2 % 2 = 0
  # 3 % 2 = 1  
  tags = {
    Name = "${local.project_name}-instance-${count.index}"
  }
}

#output of one subnet id
output "subnet_ids" {
  value = aws_subnet.tf_vpc_subnet[0].id
}

#output of all subnet ids
output "all_subnet_ids" {
  value = aws_subnet.tf_vpc_subnet[*].id
}