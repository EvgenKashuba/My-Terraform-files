#-----------------------------------------------------------------
# Created by Yevhen Kashuba
# January 2023
# This module creates AWS Instance with parameters
#
#-----------------------------------------------------------------

/*provider "aws" {
  region = "eu-central-1"
}*/

# Datasource to find a latest version of ubuntu 22.04 x64
data "aws_ami" "latest_ubuntu_22_04" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
#----------------------------------------------------------------------
# Create Instance
resource "aws_instance" "instance" {
  count                       = var.count_instance
  ami                         = var.ami_id == "ubuntu_22_04" ? data.aws_ami.latest_ubuntu_22_04.id : var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_id
  associate_public_ip_address = var.is_public
  user_data                   = var.path_to_file == "set there path to file" ? "" : file("${var.path_to_file}")
  tags = {
    Name = "${var.name_instance}-Server-${count.index + 1}"
    #Owner   = "Yevhen Kashuba"
    #Project = "Homelab"
  }
}
