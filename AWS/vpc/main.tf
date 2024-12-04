provider "aws" {
  # Configuration options
  region = "us-east-1"
}

resource "aws_vpc" "aws_vpc" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "trial-vpc"
  }
}

resource "aws_internet_gateway" "internet_gateway_for_trial_vpc" {
  vpc_id = "${aws_vpc.aws_vpc.id}"
  tags = {
    Name = "internet_gateway_for_trial_vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = "${aws_vpc.aws_vpc.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = "${aws_vpc.aws_vpc.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-2"
  }
}

# Create a Default Network ACL for private subnet
resource "aws_network_acl" "network_acl" {
  vpc_id = aws_vpc.aws_vpc.id

  # Allow all inbound traffic
  ingress {
    rule_no    = 100
    protocol   = "-1"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Allow all outbound traffic
  egress {
    rule_no    = 100
    protocol   = "-1"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "network-acl-for-subnet-2"
  }
}

# Associate Network ACL with  pricate Subnet
resource "aws_network_acl_association" "acl_association_for_private_subnet" {
  subnet_id        = aws_subnet.private_subnet_2.id
  network_acl_id   = aws_network_acl.network_acl.id
}

resource "aws_route_table" "route_table_1_for_internal_gateway" {
  vpc_id = "${aws_vpc.aws_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_for_trial_vpc.id
  }

  tags = {
    Name = "route_table_1_for_internet_gateway"
  }
}

resource "aws_route_table_association" "aws_route_table_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.route_table_1_for_internal_gateway.id
}

#elastic ip in vpc
resource "aws_eip" "Elastic_IP_for_NAT_Gateway" {
  domain = "vpc"

  tags = {
    Name = "Elastic_IP_for_NAT_Gateway"
  }
}


resource "aws_nat_gateway" "NAT_gateway_for_trial_vpc" {
  allocation_id = aws_eip.Elastic_IP_for_NAT_Gateway.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "NAT_gateway_for_trial_vpc"
  }
}

resource "aws_route_table" "route_table_2_from_NAT_gateway_to_private_subnet" {
  vpc_id = "${aws_vpc.aws_vpc.id}"

  route {
    cidr_block = "10.0.1.0/24"
    nat_gateway_id = aws_nat_gateway.NAT_gateway_for_trial_vpc.id
  }

  tags = {
    Name = "route_table_2_from_NAT_gateway_to_private_subnet"
  }
}

resource "aws_route_table_association" "aws_route_table_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.route_table_2_from_NAT_gateway_to_private_subnet.id
}
