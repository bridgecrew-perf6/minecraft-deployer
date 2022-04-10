variable "efs_dns" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3.small"
}

variable "ip_whitelist" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "name" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "ubuntu_version" {
  type = string
  default = "20.04"
}

variable "vpc_id" {
  type = string
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-${var.ubuntu_version}-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

data "template_file" "setup" {
 template = file("${path.module}/files/setup.sh.tpl")
}
