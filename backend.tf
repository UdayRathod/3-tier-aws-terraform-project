terraform {
  
  backend "s3" {
    bucket = "s3-bucket-terraform-terracloud-state"
    use_lockfile = true
    key    = "terraform-state.tf"
    region = "us-east-1"
  }
}