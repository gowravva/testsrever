resource "aws_s3_bucket" "gowri_test_server1" {
  bucket        = "gowri-test-server1"
  force_destroy = false

  tags = {
    Name  = "gowri-test-server1"
    Stack = "s3-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "gowri_test_server1_public_access_block" {
  bucket = aws_s3_bucket.gowri_test_server1.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "gowri_test_server1_sse" {
  bucket = aws_s3_bucket.gowri_test_server1.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "bucket_id" {
  description = "The name (ID) of the S3 bucket."
  value       = aws_s3_bucket.gowri_test_server1.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket.gowri_test_server1.arn
}

output "bucket_region" {
  description = "The AWS region where the bucket resides."
  value       = aws_s3_bucket.gowri_test_server1.region
}

# ── gowri-test-simple01 ──────────────────────────────────────────────────────

resource "aws_s3_bucket" "gowri_test_simple01" {
  bucket        = "gowri-test-simple01"
  force_destroy = false

  tags = {
    Name  = "gowri-test-simple01"
    Stack = "s3-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "gowri_test_simple01_public_access_block" {
  bucket = aws_s3_bucket.gowri_test_simple01.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "gowri_test_simple01_sse" {
  bucket = aws_s3_bucket.gowri_test_simple01.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "gowri_test_simple01_bucket_id" {
  description = "The name (ID) of the gowri-test-simple01 S3 bucket."
  value       = aws_s3_bucket.gowri_test_simple01.id
}

output "gowri_test_simple01_bucket_arn" {
  description = "The ARN of the gowri-test-simple01 S3 bucket."
  value       = aws_s3_bucket.gowri_test_simple01.arn
}

output "gowri_test_simple01_bucket_region" {
  description = "The AWS region where the gowri-test-simple01 bucket resides."
  value       = aws_s3_bucket.gowri_test_simple01.region
}