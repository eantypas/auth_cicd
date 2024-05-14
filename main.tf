provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket_acl" "my_bucket" {
  bucket = "cicd_auth_bucket"
  acl    = "private"
}
