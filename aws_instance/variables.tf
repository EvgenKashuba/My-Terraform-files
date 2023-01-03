# Set your Instance Name in TAGs
variable "name_instance" {
  type    = string
  default = "set-your-name"
}

# Set count of instance. By default = 1
variable "count_instance" {
  type    = number
  default = 1
}

# Set ami_id in variable "ami_id". Ubuntu 22.04 x64 (by default)
variable "ami_id" {
  type    = string
  default = "ubuntu_22_04"
}

# Set Instance type. By default "t2.micro"
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

# Set Subnet id. By default is default AWS subnet id
variable "subnet_id" {
  type    = string
  default = ""
}

# Set IDs Security Group for attach to Instance. By default is default AWS SG
variable "security_group_id" {
  default = []
}

# Set "true" if need to associate Public IP in AWS Instance
variable "is_public" {
  type = string
  #default = "true"
  default = "false"
}

# Set path to file with bootstrap data
variable "path_to_file" {
  default = "set there path to file"
  #default = "./bootstrap.sh"
}
