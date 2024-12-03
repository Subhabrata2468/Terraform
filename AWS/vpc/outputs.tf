output "aws_vpc_id" {
  value = aws_vpc.aws_vpc.id
}

output "aws_internet_gateway_id" {
  value = aws_internet_gateway.internet_gateway_for_trial_vpc.id
}

output "aws_nat_gateway_id" {
  value = aws_nat_gateway.NAT_gateway_for_trial_vpc.id
}



