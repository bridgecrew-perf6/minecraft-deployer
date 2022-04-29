resource "aws_s3_bucket" "minecraft" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "minecraft" {
  bucket  = var.bucket_name
  key     = "docker-compose.yml"
  content = templatefile("${path.module}/files/docker-compose.yml.tpl", {
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
  })

  depends_on = [aws_s3_bucket.minecraft]
}

resource "aws_s3_bucket_acl" "minecraft" {
  bucket = aws_s3_bucket.minecraft.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "minecraft" {
  bucket = aws_s3_bucket.minecraft.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "minecraft" {
  bucket = aws_s3_bucket.minecraft.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "minecraft" {
  bucket = aws_s3_bucket.minecraft.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}
