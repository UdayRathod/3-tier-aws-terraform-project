module "web_app_s3" {
  source = "./modules/terracloud-web-app-s3"

  bucket_name             = local.s3_bucket_name
  elb_service_account_arn = data.aws_elb_service_account.root.arn
  common_tags             = local.common_tags
}

resource "aws_s3_object" "website_content" {
  for_each = local.website_content

  bucket = module.web_app_s3.web_bucket.id
  key    = each.value
  source = "${path.root}/${each.value}"

  tags = local.common_tags

}



# S3 bucket for backend, we did not used aboe s3 module as that module is create iam polices, role releated to ALB.

resource "aws_s3_bucket" "backend-s3" {
  bucket = "s3-bucket-terraform-terracloud-state"

  tags = local.common_tags
}

# Enabling default encryption on backend S3 bucket
resource "apply_server_side_encryption_by_default" "backend-s3-encrpytion" {
  bucket = aws_s3_bucket.backend-s3.id
  rule {
    sse_algorithm = "AES256"
  }
}

# Enabling versioning on backend S3 bucket
resource "aws_s3_bucket_versioning" "backend-s3-versioning" {
  bucket = aws_s3_bucket.backend-s3.id
  versioning_configuration {
    status = "Enabled"
  }
}