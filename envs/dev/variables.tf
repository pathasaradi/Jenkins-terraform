variable "region"           { type = string }
variable "name"             { type = string }
variable "vpc_cidr"         { type = string }
variable "azs"              { type = list(string) }
variable "public_subnets"   { type = list(string) }
variable "private_subnets"  { type = list(string) }

variable "app_port"         { type = number }
variable "ami_id"           { type = string }
variable "instance_type"    { type = string }
variable "min_size"         { type = number }
variable "max_size"         { type = number }
variable "desired_capacity" { type = number }
