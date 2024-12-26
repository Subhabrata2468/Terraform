variable "vpc_config" {
  description = "To get the CIDR and the name of the vpc from user"
  type = object({
    cidr_block = string
    vpc_name = string
  })
}