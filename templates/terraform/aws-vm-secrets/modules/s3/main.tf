# S3 bucket with unique naming
resource "aws_s3_bucket" "main" {
  bucket = "${var.bucket_name_prefix}-${var.random_suffix}"

  tags = merge(var.common_tags, {
    Name = "${var.bucket_name_prefix}-${var.random_suffix}"
  })
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    id     = "transition_to_ia"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }

  rule {
    id     = "delete_incomplete_multipart_uploads"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# S3 bucket notification for CloudWatch (optional)
resource "aws_s3_bucket_notification" "main" {
  bucket = aws_s3_bucket.main.id

  # CloudWatch configuration can be added here if needed
}

# Create some sample folders/objects
resource "aws_s3_object" "folders" {
  for_each = toset(var.folder_names)
  
  bucket = aws_s3_bucket.main.id
  key    = "${each.value}/"
  
  tags = var.common_tags
}
