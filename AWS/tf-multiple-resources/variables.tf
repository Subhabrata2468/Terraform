variable "ec2_instance_ami" {
  type = list(object({
    ami = string
  }))

}

variable "ec2_instance_ami_map" {
  # key-value pair
  type = map(object({
    ami = string
  }))
}