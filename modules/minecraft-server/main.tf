resource "aws_instance" "minecraft" {
  ami                    = data.aws_ami.ubuntu.id
  iam_instance_profile   = aws_iam_instance_profile.minecraft.id
  instance_type          = var.instance_type
  subnet_id              = var.subnets[0]
  vpc_security_group_ids = [aws_security_group.minecraft.id]
  user_data              = data.template_file.setup.rendered

  root_block_device {
    delete_on_termination = true
    volume_size           = 20
    volume_type           = "gp3"
  }

  tags = {
    Name = var.name
  }
}

resource "aws_eip" "minecraft" {
  vpc = true
}

resource "aws_eip_association" "minecraft" {
  instance_id   = aws_instance.minecraft.id
  allocation_id = aws_eip.minecraft.id
}

resource "aws_security_group" "minecraft" {
  name        = "${var.name}-server"
  vpc_id      = data.aws_vpc.main.id

  // Allow access from IP whitelist
  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = var.ip_whitelist
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ip" {
  value = aws_eip.minecraft.public_ip
}
