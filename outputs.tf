output "vpc_id" {
  description = "作成した VPC の ID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "パブリックサブネットの ID"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "プライベートサブネットの ID"
  value       = module.network.private_subnet_ids
}

output "log_bucket" {
  description = "ログ保管用バケット名"
  value       = aws_s3_bucket.logs.bucket
}
