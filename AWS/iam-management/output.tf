output "iml-data-without-decoding" {
  value = local.iml_data
}

output "iml-data-with-decoding" {
  value = local.iml_data_decoded
}

output "users-names" {
  value = local.all_users_names
}

output "groups-names" {
  value = local.all_groups_name
}

output "teams-names" {
  value = local.teams
}

output "policy-names" {
  value = toset(flatten([
    yamldecode(local.iml_data).developers[*].permissions,
    yamldecode(local.iml_data).operations[*].permissions,
    yamldecode(local.iml_data).db_admins[*].permissions,
    yamldecode(local.iml_data).security[*].permissions
  ]))
}
output "pairing-users-with-groups" {
  value = local.pair_users_groups
}

output "giving-permissions-to-users" {
  value = local.pair_user_permission
}

output "group-groups_policies" {
  value = local.groups_policies
}

output "pairing-policies-with-group" {
  value = local.pair_group_policy
}

output "password-policies" {
  value = local.password_policy
}

