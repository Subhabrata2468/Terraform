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

resource "aws_instance" "ec2_instance" {
  ami = var.aws_ami
  instance_type = var.aws_instance_type

  root_block_device {
    volume_size = var.ec2_config.v_size
    volume_type = var.ec2_config.v_type
    delete_on_termination = true
  }

  tags = merge(var.additional_tags,{
    Name = "ec2-instance"
  })
}