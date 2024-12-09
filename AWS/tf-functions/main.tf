terraform {
  
}

locals {
 value = "hello , world" 
}

# convert the string to upper case that is present in the local.value
output "output_1" {
  value = upper(local.value)
}

# convert the string to lower case that is present in the local.value
output "output_2" {
  value = lower(local.value)
}

# returns boolean value true, if local.value starts with hello
output "output_3" {
  value = startswith(local.value, "hello")
}

# return boolean value true, if local.value ends with world
output "output_4" {
  value = endswith(local.value, "world")
}

# return the first 4 characters of local.value including the 0th index and excluding the 4th index
output "output_5" {
  value = substr(local.value, 0, 4)
}

# return the length of local.value
output "output_6" {
  value = length(local.value)
}

# splits a string into a list
output "output_7" {
  value = split(" ", local.value)
}

# returns the maximum value
output "output_8" {
  value = max(1,8,2,3,9,0,10)
}

# returns the minimum value
output "output_9" {
  value = min(1,8,2,3,9,0,10)
}


variable "string_list" {
  type = list(string)
  default = [ "server1", "server2","server3","server1" ]
}

# returns the length of the list
output "output_10" {
  value = length(var.string_list)
}

# joins the elements of the list with -
output "output_11" {
  value = join("-", var.string_list)
}

# returns true if the string is present in the list
output "output_12" {
  value = contains(var.string_list, "server1")
}

# returns the unique elements of the list
output "output_13" {
  value = var.string_list
}

# returns the unique elements of the list
output "output_14" {
  value = toset(var.string_list)
}