// aws_rds_cluster
output "aurora_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.default.endpoint
}

output "alb_dns" {
  value       = aws_alb.alb.dns_name
}

output "s3_bucket" {
  description = "S3 Bucket"
  value       = aws_s3_bucket.b.id
}

