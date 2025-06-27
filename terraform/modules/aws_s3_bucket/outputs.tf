
output "name" {
  value = aws_s3_bucket.this.bucket
}

output "regional_domain_name" {
  value = aws_s3_bucket.this.bucket_regional_domain_name
}

output "id" {
  value = aws_s3_bucket.this.id
}
