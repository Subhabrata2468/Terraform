resource "aws_vpc" "vpc-main" {
  cidr_block = var.vpc_config.cidr_block
  
  tags = {
    Name = var.vpc_config.vpc_name
  }
}

resource "aws_subnet" "subnets_main" {
  vpc_id = aws_vpc.vpc-main.id
  for_each = var.aws_subnets

  cidr_block = each.value.cidr_block  
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.key
  }
}

locals {
  public_subnets = {
    #public_sub1 = {cidr_block = "10.0.1.0/24", availability_zone = "us-east-1a", public = true}
    for key, config  in var.var.aws_subnets : key => config if config.public
  }
}

#internet gateway, if there is atleast one public subnet 
#internet gateway will be created only once
resource "aws_internet_gateway" "main" {
  vpc_id =  aws_vpc.vpc-main.id
  count = length(local.public_subnets) > 0 ? 1 : 0
}
