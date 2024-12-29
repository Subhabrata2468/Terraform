This is the complete config to work with this module.

## Usage

```
module "vpc" {
  source = "./modules/vpc"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    vpc_name = "test_vpc"
  }

  aws_subnets = {
    public_sub1 = {
      cidr_block = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      # To set the subnet as public, default is private
      public = true
    }
    public_sub2 = {
      cidr_block = "10.0.2.0/24"
      availability_zone = "us-east-1b"
      public = true
    }
    private_sub3 = {
      cidr_block = "10.0.3.0/24"
      availability_zone = "us-east-1c"
      public = false
    }
  }
}
```
