# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source for latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# IAM role for EC2 instance
resource "aws_iam_role" "ec2_role" {
  name = "${var.instance_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.common_tags
}

# IAM policy for accessing Secrets Manager and S3
resource "aws_iam_role_policy" "ec2_policy" {
  name = "${var.instance_name}-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      }
    ]
  })
}

# Instance profile for the IAM role
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.instance_name}-profile"
  role = aws_iam_role.ec2_role.name

  tags = var.common_tags
}

# User data script to install AWS CLI and configure instance
locals {
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    ec2_username   = var.ec2_username
    ec2_password   = var.ec2_password
    s3_bucket_name = var.s3_bucket_name
  }))
}

# EC2 instance
resource "aws_instance" "main" {
  ami                     = var.use_ubuntu ? data.aws_ami.ubuntu.id : data.aws_ami.amazon_linux.id
  instance_type           = var.instance_type
  key_name                = var.key_pair_name
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = var.security_group_ids
  iam_instance_profile    = aws_iam_instance_profile.ec2_profile.name
  user_data               = local.user_data

  root_block_device {
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size
    encrypted   = true
  }

  tags = merge(var.common_tags, {
    Name = var.instance_name
  })
}
