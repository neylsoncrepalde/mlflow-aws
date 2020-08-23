// aws_rds_cluster
output "mysql_id" {
  description = "The ID of the cluster"
  value       = aws_db_instance.default.id
}

output "mysql_endpoint" {
  description = "The cluster endpoint"
  value       = aws_db_instance.default.endpoint
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

