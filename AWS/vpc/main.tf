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

resource "aws_route_table" "route_table_1_for_internal_gateway" {
  vpc_id = "${aws_vpc.aws_vpc.id}"

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "local"
  }

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.internet_gateway_for_trial_vpc.id
  }

  tags = {
    Name = "route_table_1_for_internet_gateway"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.route_table_1_for_internal_gateway.id
}
