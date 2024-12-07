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
