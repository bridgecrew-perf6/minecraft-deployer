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

resource "aws_efs_file_system_policy" "main" {
  file_system_id = aws_efs_file_system.main.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "Policy01",
  "Statement": [
    {
      "Sid": "Statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "${aws_efs_file_system.main.arn}",
      "Action": [
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientRootAccess",
        "elasticfilesystem:ClientWrite"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_efs_mount_target" "main" {
  count = length(var.subnets)

  file_system_id = aws_efs_file_system.main.id
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
