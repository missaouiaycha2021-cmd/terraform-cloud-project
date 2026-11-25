output "bucket_name" {
  description = "Nom du bucket applicatif"
  value       = aws_s3_bucket.app.id
}

output "bucket_arn" {
  description = "ARN du bucket applicatif"
  value       = aws_s3_bucket.app.arn
}