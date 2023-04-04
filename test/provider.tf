terraform {
  required_version = ">= 0.13"
  backend "s3" {
    bucket = "multicloud-brian-bucket"
    key    = "terraform-backend/state-module-test"
    region = "us-gov-west-1"
  }
}