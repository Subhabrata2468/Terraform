output "vpc_id" {
  description = "diplay the vpc id"
  value = aws_vpc.vpc-main.id
}

locals {
#output format of subnets ids is subnet_name = {subnet_id, availability_zone}
 public_subnet_output={
     for key , config in local.public_subnets : key => {
        subnet_id = aws_subnet.subnets_main[key].id
        availability_zone = aws_subnet.subnets_main[key].availability_zone
     }
 }  

 private_subnet_output={
     for key , config in local.public_subnets : key => {
        subnet_id = aws_subnet.subnets_main[key].id
        availability_zone = aws_subnet.subnets_main[key].availability_zone
     }
 }
}

output "public-subnet-ids" {
  description = "list of public subnet ids"
  value = local.public_subnet_output
}

output "private-subnet-ids" {
  description = "list of private subnet ids"
  value = local.private_subnet_output
}