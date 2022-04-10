variable "bucket_name" {
  default = "minecraft-ec2"
}

variable "name" {
  default = "minecraft-ec2"
}

variable "region" {
  default = "us-west-2"
}

variable "profile" {
  default = "default"
}

terraform {
  required_version = "1.1.8"
  backend "local" {}
}

provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = {
      Environment = var.name
    }
  }
}

module "network" {
  source = "../modules/network"

  vpc_enable_dns_hostnames = true
}

module "efs" {
  source = "../modules/efs"

  name = var.name
  subnets = module.network.public_subnets
  vpc_id = module.network.vpc_id
}

module "minecraft-server" {
  source = "../modules/minecraft-server"

  bucket_name = var.bucket_name
  efs_dns = module.efs.efs-mount-target-dns
  name = var.name
  subnets = module.network.public_subnets
  vpc_id = module.network.vpc_id
}

output "minecraft_ip" {
  value = module.minecraft-server.ip
}
