# provider
terraform {
    backend "s3" {
      bucket = "xxxxxxxxxxxx"
      key    = "xxxxxxxxxxx"
      region = "xxxxxxxxxxx"
    }
}

provider "aws" {
  region = var.aws_region
}
