variable "aws_ami" {
  description = "value of ami-id"
  type = string
  default = "ami-0453ec754f44f9a4a"
}

variable "aws_instance_type" {
    description = "Give me te instance id"
    type = string
    validation {
        condition = var.aws_instance_type == "t2.micro" || var.aws_instance_type == "t2.nano"
        error_message = "The instance type must be t2.micro or t2.nano"
    }
}

variable "ec2_config" {
  type = object({
    v_size = number
    v_type = string
  })
  default = {
    v_size = 20
    v_type = "gp2"
  }
}

variable "additional_tags" {
  type = map(string)
  default = {          #can give any number of tags
    "name" = "value"
  }
}
#variable "root_block_device_size" {
#  description = "Volume size"
#  type = number
#  default = 20
#}

#variable "root_block_device_type" {
#  description = "Volume type"
#  type = string
#  default = "gp2"
#}