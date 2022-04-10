# IAM
resource "aws_iam_role" "minecraft" {
  name = var.name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "minecraft" {
  name = var.name
  role = aws_iam_role.minecraft.name
}

resource "aws_iam_role_policy" "minecraft" {
  name = "policy"
  role = aws_iam_role.minecraft.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::${var.bucket_name}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::${var.bucket_name}/*"]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "managed" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.minecraft.id
}

resource "aws_iam_role_policy_attachment" "session" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.minecraft.id
}
