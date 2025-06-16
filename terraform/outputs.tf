
output "s3_bucket_name" {
  value = module.aws_s3_bucket.name
}

output "s3_bucket_role_arn" {
  value = module.aws_iam_role.arn
}
