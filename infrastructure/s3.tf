resource "aws_s3_bucket" "b" {
  bucket = "${var.project_name}-${var.stage}-${var.account}"
  acl    = "private"
}