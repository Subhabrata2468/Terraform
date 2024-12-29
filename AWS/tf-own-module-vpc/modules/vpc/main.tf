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
    for key, config  in var.aws_subnets : key => config if config.public
  }
  
   private_subnets = {
    for key, config  in var.aws_subnets : key => config if !config.public
  }
}

#internet gateway, if there is atleast one public subnet 
#internet gateway will be created only once
resource "aws_internet_gateway" "igw_main" {
  vpc_id =  aws_vpc.vpc-main.id
  count = length(local.public_subnets) > 0 ? 1 : 0
}

resource "aws_route_table" "route_main" {
  vpc_id = aws_vpc.vpc-main.id
  count = length(local.public_subnets) > 0 ? 1 : 0

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_main[0].id
  }
}

resource "aws_route_table_association" "route_table_association_main" {
  for_each = local.public_subnets
  subnet_id = aws_subnet.subnets_main[each.key].id
  route_table_id = aws_route_table.route_main[0].id
}
