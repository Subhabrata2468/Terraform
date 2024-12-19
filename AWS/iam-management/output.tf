output "users-names" {
  value = toset(concat(
    yamldecode(local.iml_data).developers[*].username,
    yamldecode(local.iml_data).operations[*].username,
    yamldecode(local.iml_data).db_admins[*].username,
    yamldecode(local.iml_data).security[*].username
  ))
}

output "groups-names" {
  value = toset(flatten([
    yamldecode(local.iml_data).developers[*].groups,
    yamldecode(local.iml_data).operations[*].groups,
    yamldecode(local.iml_data).db_admins[*].groups,
    yamldecode(local.iml_data).security[*].groups
  ]))
}

output "policy-names" {
  value = toset(flatten([
    yamldecode(local.iml_data).developers[*].permissions,
    yamldecode(local.iml_data).operations[*].permissions,
    yamldecode(local.iml_data).db_admins[*].permissions,
    yamldecode(local.iml_data).security[*].permissions
  ]))
}
output "" {
  value = local.pair_users_groups
}

output "" {
  value = local.pair_user_permission
}

output "" {
  value = local.pair_group_policy
}

output "" {
  value = 
}

