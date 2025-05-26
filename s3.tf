module "web_app_s3" {
  source = "./modules/terracloud-web-app-s3"

  bucket_name             = local.s3_bucket_name
  elb_service_account_arn = data.aws_elb_service_account.root.arn
  common_tags             = local.common_tags
}

resource "aws_s3_object" "website_content" {
  for_each = local.website_content

  bucket = module.web_app_s3.web_bucket.id
  key    = each.key == "website" ? "website/index.php" : "website/Terracloud.png"
  source = "${path.module}/${each.value}"

  tags = local.common_tags

}



