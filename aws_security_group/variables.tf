# Set your name of SG in TAGs
variable "name_sg" {
  type    = string
  default = "set-your-name"
}

# Set default VPC id. If you want to set your VPC id - please, set id instead def_id
variable "vpc_id" {
  default = "def_id"
}

# Set ports to allow anyware (0.0.0.0/0) you need in list (example default = ["80", "443"])
variable "allow_ports_public" {
  type    = list(any)
  default = []
}

# Set ports to allow only in your VPC cidr in list (example default = ["8080", "22"])
variable "allow_ports_private" {
  type    = list(any)
  default = []
}
