resource "aws_s3_bucket" "minecraft" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "minecraft" {
  bucket = aws_s3_bucket.minecraft.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "minecraft" {
  bucket = aws_s3_bucket.minecraft.id

  block_public_acls   = true
  block_public_policy = true
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
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
