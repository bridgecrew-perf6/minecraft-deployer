variable "bucket_name" {
  default = "minecraft-ec2-deployer"
}

variable "ip_whitelist" {
  type = list(string)
  default = ["0.0.0.0/0"]
}

variable "minecraft_ops" {
  default = ""
}

variable "minecraft_version" {
  default = "latest"
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
  backend "s3" {}
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
  ip_whitelist = var.ip_whitelist
  name = var.name
  subnets = module.network.public_subnets
  vpc_id = module.network.vpc_id

  # MINECRAFT CFG
  minecraft_ops     = var.minecraft_ops
  minecraft_version = var.minecraft_version
}

output "minecraft_ip" {
  value = module.minecraft-server.ip
}

resource "null_resource" "minecraft_server_tag" {
  provisioner "local-exec" {
    command = <<-EOT
    aws ec2 create-tags \
      --resources ${module.minecraft-server.spot_id} \
      --tags Key=Name,Value=${var.name} \
      --region ${var.region} \
      --profile ${var.profile}
  EOT
  }
}