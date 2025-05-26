locals {
  common_tags = {
    company      = var.company
    project      = "${var.company}-${var.project}"
    billing_code = var.billing_code
    environment  = var.environment
    Managed_by   = "Terraform"
  }

  s3_bucket_name = "${lower(local.naming_prefix)}-s3"

  website_content = {
    website = "website/rendered_index.php"
    logo    = "website/Terracloud.png"
  }

  naming_prefix = "${var.naming_prefix}-${var.environment}"
}

resource "random_integer" "s3" {
  min = 10000
  max = 99999
}