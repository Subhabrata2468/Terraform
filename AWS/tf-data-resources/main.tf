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
  region = "us-east-1"
}

data "aws_ami" "name" {
    most_recent = true
    owners = [ "amazon" ]
  
}

output "aws_ami" { 
  value = data.aws_ami.name.id

}

resource "aws_instance" "myec2" {
    ami = data.aws_ami.name.id
    instance_type = "t2.nano"
    subnet_id =
    security_groups = 

    tags = {
        Name = "Myec2"
    }
}  