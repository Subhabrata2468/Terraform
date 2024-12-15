output "users-names" {
  value = concat(
    yamldecode(local.iml_data).developers[*].username,
    yamldecode(local.iml_data).operations[*].username,
    yamldecode(local.iml_data).db_admins[*].username,
    yamldecode(local.iml_data).security[*].username
  )
}

output "groups-names" {
  value = concat(
    yamldecode(local.iml_data).developers[*].groups,
    yamldecode(local.iml_data).operations[*].groups,
    yamldecode(local.iml_data).db_admins[*].groups,
    yamldecode(local.iml_data).security[*].groups
  )
}