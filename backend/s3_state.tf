# S3 bucket provisioning for backend, since the backend config requeires the S3 to be available initially.


resource "aws_s3_bucket" "backend-s3" {
  bucket = "s3-bucket-terraform-terracloud-state"

  tags = {
    company      = "TerraCloud"
    project      = "Terra-cloud-app"
    billing_code = "TC786000"
    environment  = "Prod"
    Managed_by   = "Terraform"

  }
}

# Using AES256 encryption on S3
resource "aws_s3_bucket_server_side_encryption_configuration" "backend-s3-encryption" {
  bucket = aws_s3_bucket.backend-s3.bucket
  rule {
    apply_server_side_encryption_by_default {
      # Choose your encryption algorithm
      sse_algorithm = "AES256"

    }
  }
}

# Enabling versioning on backend S3 bucket
resource "aws_s3_bucket_versioning" "backend-s3-versioning" {
  bucket = aws_s3_bucket.backend-s3.id
  versioning_configuration {
    status = "Enabled"
  }
}