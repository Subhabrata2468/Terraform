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

#ami-id
data "aws_ami" "name" {
    most_recent = true
    owners = [ "amazon" ]
}

#ami-id output
output "aws_ami" { 
  value = data.aws_ami.name.id
}

# vpc-id
data "aws_vpc" "name" {
  tags = {
    Name = "trial-vpc"
  }
}

#vpc-id output
output "aws_vpc" { 
  value = data.aws_vpc.name.id

}

#subnet-id
data "aws_subnet" "example" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.name.id]
  }
  tags = {
    Name= "public-subnet-1"
  }
}

#subnet-id output
output "aws_subnet" {
  value = data.aws_subnet.example.id
}

#security-group
data "aws_security_group" "name" {
  tags = {
    Name = "Security_Group_1"
  }
}

#security-group output
output "aws_security_group" {
  value = data.aws_security_group.name.id
}

#instance-creation
resource "aws_instance" "myec2" {
    ami = "ami-0453ec754f44f9a4a"
    instance_type = "t2.nano"
    subnet_id = data.aws_subnet.example.id
    security_groups = [data.aws_security_group.name.id]
    tags = {
        Name = "Myec2"
    }
}  