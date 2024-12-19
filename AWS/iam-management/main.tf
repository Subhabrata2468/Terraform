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

# Local variables for processing user and group data from YAML
locals {
  #users = yamldecode(file("${path.module}/users.yaml"))
  iml_data = file("./users.yaml")

  iml_data_decoded = yamldecode(local.iml_data)

  # Get all user names across different teams
  all_users_names= toset(concat(
    local.iml_data_decoded.developers[*].username,
    local.iml_data_decoded.operations[*].username,
    local.iml_data_decoded.db_admins[*].username,
    local.iml_data_decoded.security[*].username
  ))

  # To get all the group names
  all_groups_name=toset(flatten([
    yamldecode(local.iml_data).developers[*].groups,
    yamldecode(local.iml_data).operations[*].groups,
    yamldecode(local.iml_data).db_admins[*].groups,
    yamldecode(local.iml_data).security[*].groups
  ]))

  # List of all teams from YAML
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

  # Get groups and their policies from YAML
  groups_policies = local.iml_data_decoded.groups
  
  # Create pairs of groups and their assigned policies
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

  # Create pairs of users and their directly assigned permissions
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

  # Get password policy configuration from YAML
  password_policy = local.iml_data_decoded.password_policy
}


# Create IAM users for all team members
resource "aws_iam_user" "users" {
  for_each = local.all_users_names
  name = each.value
}

# Generate AWS access keys for all users
resource "aws_iam_access_key" "user_keys" {
  for_each = local.all_users_names
  user = each.key
}

# Set up console access for users with initial password requirements
resource "aws_iam_user_login_profile" "user_login_profile" {
  for_each = local.all_users_names
  user     = each.key
  password_length = 20
  password_reset_required = true
}

# Configure organization-wide password policy settings
resource "aws_iam_account_password_policy" "password_policy" {
  minimum_password_length        = local.password_policy.minimum_length
  require_uppercase_characters   = local.password_policy.require_uppercase
  require_lowercase_characters   = local.password_policy.require_lowercase
  require_numbers                = local.password_policy.require_numbers
  require_symbols                = local.password_policy.require_symbols
  max_password_age               = local.password_policy.max_age_days
  password_reuse_prevention      = local.password_policy.prevent_reuse

  # Optional: Allow users to change their own password
  allow_users_to_change_password = true
}

# Create IAM groups for different team roles
resource "aws_iam_group" "groups" {
  for_each = local.all_groups_name
  name = each.value
}

# Assign users to their respective IAM groups
resource "aws_iam_user_group_membership" "pairing_users_groups" {
  for_each = local.pair_users_groups

  user   = each.value.username
  groups = [each.value.group]
}

# Attach AWS managed policies to IAM groups
resource "aws_iam_group_policy_attachment" "group_policy_attachment" {
  for_each = local.pair_group_policy
  group    = each.value.group_name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.policy}"
}

# Attach AWS managed policies directly to users
resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  for_each = local.pair_user_permission
  user       = each.value.username
  policy_arn = "arn:aws:iam::aws:policy/${each.value.permission}"
}
