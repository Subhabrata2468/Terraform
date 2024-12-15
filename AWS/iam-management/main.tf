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
  region = "us-east-1"
}

locals {
  #users = yamldecode(file("${path.module}/users.yaml"))
  iml_data = file("./users.yaml")
}

resource "aws_iam_user" "users" {
  for_each = toset(concat(
    yamldecode(local.iml_data).developers[*].username,
    yamldecode(local.iml_data).operations[*].username,
    yamldecode(local.iml_data).db_admins[*].username,
    yamldecode(local.iml_data).security[*].username
  ))
  name = each.value
}

resource "aws_iam_group" "developers" {
  for_each = toset(flatten([
    yamldecode(local.iml_data).developers[*].groups,
    yamldecode(local.iml_data).operations[*].groups,
    yamldecode(local.iml_data).db_admins[*].groups,
    yamldecode(local.iml_data).security[*].groups
  ]))
  name = each.value

}