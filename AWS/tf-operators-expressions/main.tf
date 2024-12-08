 terraform {
 }

 # Number List 
 variable "num_list" {
   type = list(number)
   default = [1,2,3]
 }

 # Object List of number
 variable "person_list" {
   type = list(object({
     name = string
     age = number
   }))

   default = [
     {
       name = "John"
       age = 30
     },
     {
       name = "Jane"
       age = 25
     },
     {
       name = "Jony"
       age = 40
     }
   ]
 }
  
# map, based on key and value pair 
# jist like dictionary in python
variable "map_list" {
  type = map(number)
  default = {
    "name" = 1
    "age" = 2
  }
}



#calculation
locals {
    mul =2 * 2
    add = 2 + 2
    sub = 2 - 2
    div = 2 / 2
    not_equal = 2 != 3

    #to get the double
    double= [for i in var.num_list : i * 2]
    
    #to get the odd number
    odd= [for i in var.num_list : i if i % 2 != 0]

    #to get the names of the person from the above map list
    name = [for i in var.person_list : i.name]

    # work with map
    map_info= [for key, value in var.map_list : value]

    #double map 
    double_map_info= [for key, value in var.map_list : value * 2]
}

output "output_1" {
  value = local.mul
}

output "output_2" {
  value = local.not_equal 
}

output "output_3" {
  value = var.num_list
}

output "output_4" {
  value = local.double
}

output "output_5" {
  value = local.odd
}

output "output_6" {
  value = local.name
}

output "output_7" {
  value = local.map_info
}

output "output_8" {
  value = local.double_map_info
}