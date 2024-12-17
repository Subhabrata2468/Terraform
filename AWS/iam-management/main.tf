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

  iml_data_decoded = yamldecode(local.iml_data)
  teams = [
      local.iml_data_decoded.developers,
      local.iml_data_decoded.operations,
      local.iml_data_decoded.db_admins,
      local.iml_data_decoded.security
    ]
  # Extract users and their groups as pairs 
  pair_users_groups = {
    for pair in flatten([
      for team in local.teams : [
        for user in team : [
          for group in user.groups : {
            username = user.username,
            group    = group
          }
        ]
      ]
    ]) : "${pair.username}-${pair.group}" => pair
  }

  groups_policies = local.iml_data_decoded.groups
# Pairing group and policy
  pair_group_policy = {
    for pair in flatten([
      for group_name, group_obj in local.groups_policies : [
        for policy in lookup(group_obj, "policies", []) : {
          group_name = group_name
          policy     = policy
        }
      ]
    ]) : "${pair.group_name}-${pair.policy}" => pair
  }

  # Pairing user and permissions
  pair_user_permission= {
    for pair in flatten([
      for team in local.teams:[
        for user in team:[
          for permission in user.permissions :{
            username = user.username,
            permission = permission
          }
        ]
      ]
    ]) : "${pair.username}-${pair.permission}" => pair
  }
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

resource "aws_iam_group" "groups" {
  for_each = toset(flatten([
    yamldecode(local.iml_data).developers[*].groups,
    yamldecode(local.iml_data).operations[*].groups,
    yamldecode(local.iml_data).db_admins[*].groups,
    yamldecode(local.iml_data).security[*].groups
  ]))
  name = each.value
}



resource "aws_iam_user_group_membership" "pairing_users_groups" {
  for_each = local.pair_users_groups

  user   = each.value.username
  groups = [each.value.group]
}

resource "aws_iam_group_policy" "group_policy" {
  for_each = local.pair_group_policy
  group    = each.value.group_name
  policy   = each.value.policy
}

resource "aws_iam_user_policy" "user_policy" {
  for_each = local.pair_user_permission
  user     = each.value.username
  policy   = each.value.permission
}
