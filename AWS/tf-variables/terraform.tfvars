aws_ami = "ami-0453ec754f44f9a4a"

aws_instance_type = "t2.nano"

ec2_config = {
  v_size = 20
  v_type = "gp2"
}

additional_tags = {
  project = "terrafrom"
  cloud = "aws"
}