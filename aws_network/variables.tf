# Region for deploy this infrastructure
variable "region" {
  #  description = "Please, enter AWS Region to deploy this infrastructure"
  type    = string
  default = "eu-central-1"
}

# Variable for tag Name in all created resources
variable "name_env" {
  type    = string
  default = "project1"
}

# VPC cidr block
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

# Public subnets cidr blocks. Write the cider you need.
# For example:
# default = [
#   "10.0.10.0/24",
#   "10.0.11.0/24",
# ] - in this case will be create 2 subnets.
# If default = [] - 0 subnet will be create
variable "public_subnet_cidr" {
  default = [
    "10.0.10.0/24",
    "10.0.11.0/24",
  ]
}

# Private subnets cidr blocks. Write the cider you need.
# For example:
# default = [
#   "10.0.20.0/24",
#   "10.0.21.0/24",
# ] - in this case will be create 2 subnets.
# If default = [] - 0 subnet will be create
variable "private_subnet_cidr" {
  default = [
    #    "10.0.20.0/24",
  ]
}
