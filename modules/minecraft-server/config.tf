
variable "bucket_name" {
  type = string
}

variable "efs_dns" {
  type = string
}

variable "efs_mount_location" {
  type = string
  default = "/mnt/efs"
}

variable "instance_type" {
  type = string
  default = "t3.medium"
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

data "template_file" "docker" {
 template = file("${path.module}/files/docker-compose.yml.tpl")

  vars = {
    minecraft_enable_rcon = var.minecraft_enable_rcon
    minecraft_eula        = "true"
    minecraft_init_memory = var.minecraft_init_memory
    minecraft_max_memory  = var.minecraft_max_memory
    minecraft_motd        = var.minecraft_motd
    minecraft_mount       = "${var.efs_mount_location}/minecraft"
    minecraft_ops         = var.minecraft_ops
    minecraft_override    = "true"
    minecraft_port        = var.minecraft_port
    minecraft_version     = var.minecraft_version
  }
}

data "template_file" "setup" {
 template = file("${path.module}/files/setup.sh.tpl")

  vars = {
    bucket_name = var.bucket_name
    efs_dns = var.efs_dns
    efs_mount_location = var.efs_mount_location
  }
}
