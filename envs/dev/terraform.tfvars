region           = "ap-south-1"
name             = "demo-app"

vpc_cidr         = "10.0.0.0/16"
azs              = ["ap-south-1a", "ap-south-1b"]
public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

app_port         = 80
ami_id           = "ami-0c1a7f89451184c8b"
instance_type    = "t3.micro"

min_size         = 2
max_size         = 4
desired_capacity = 2  # fixed comment style
