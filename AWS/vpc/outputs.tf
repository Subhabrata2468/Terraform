output "aws_vpc_id" {
  value = aws_vpc.aws_vpc.id
}

output "aws_subnet_id" {
  value = aws_subnet.public_subnet_1.id
}

output "aws_subnet_id" {
  value = aws_subnet.public_subnet_2.id
}

output "aws_internet_gateway_id" {
  value = aws_internet_gateway.internet_gateway_for_trial_vpc.id
}

output "aws_route_table_id" {
  value = aws_route_table.route_table_1_from_internet_gateway_to_public_subnet.id
}

output "aws_route_table_association_id" {
  value = aws_route_table_association.aws_route_table_association_1.id
}

output "aws_nat_gateway_id" {
  value = aws_nat_gateway.NAT_gateway_for_trial_vpc.id
}

output "aws_route_table_id" {
  value = aws_route_table.route_table_2_from_NAT_gateway_to_private_subnet.id
}

output "aws_route_table_association_id" {
  value = aws_route_table_association.aws_route_table_association_2.id
}

