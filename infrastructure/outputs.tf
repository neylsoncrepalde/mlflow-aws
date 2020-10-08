// aws_rds_cluster
output "aurora_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.default.endpoint
}

output "ec2_public_dns" {
  value       = aws_instance.web.public_dns
}

output "ec2_public_ip" {
  value       = aws_instance.web.public_ip
}

output "s3_bucket" {
  description = "S3 Bucket"
  value       = aws_s3_bucket.b.id
}

