variable "name" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_efs_file_system" "main" {
  lifecycle_policy {
    transition_to_ia = "AFTER_7_DAYS"
  }

  tags = {
    Name = var.name
  }
}

resource "aws_efs_mount_target" "main" {
  # for_each = toset(var.subnets)
  count = length(var.subnets)

  file_system_id = aws_efs_file_system.main.id
  # subnet_id      = each.key
  subnet_id      = "${element(var.subnets, count.index)}"

  security_groups = [
    aws_security_group.main.id,
  ]
}

resource "aws_security_group" "main" {
  name        = "${var.name}-efs"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      data.aws_vpc.main.cidr_block,
    ]
  }

  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      data.aws_vpc.main.cidr_block,
    ]
  }
}

output "efs-mount-target-dns" {
  value = aws_efs_mount_target.main.0.dns_name
}
