# provider
data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket = var.tf_state_bucket
    key    = var.tf_state_key
    region = var.aws_region
  }
}

provider "aws" {
  region = var.aws_region
}
