#----------------------------------------------------#
# This code deploys Security Group in VPC            #
# All parameters you can write in variables.tf       #
# Created by Yevhen Kashuba, december 2022           #
#----------------------------------------------------#
/*provider "aws" {
  region = "eu-central-1"
}*/
# Get the VPC id
data "aws_vpc" "default" {
  default = true
}

# Check VPC id to default on no
data "aws_vpc" "selected" {
  id = var.vpc_id == "def_id" ? data.aws_vpc.default.id : var.vpc_id
}

# Create Security Group for Frontend instance
resource "aws_security_group" "main_sg" {
  name   = "allow_traffic"
  vpc_id = data.aws_vpc.selected.id

  dynamic "ingress" {
    for_each = var.allow_ports_public
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "ingress" {
    for_each = var.allow_ports_private
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [data.aws_vpc.selected.cidr_block]
    }
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_env}-SG"
  }
}
