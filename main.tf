data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

module "network" {
  source = "./modules/network"

  name     = var.project
  vpc_cidr = var.vpc_cidr
  azs      = local.azs
}

# ログ保管用の S3 バケット（暗号化・公開ブロック・バージョニング・古いログの自動削除）
resource "aws_s3_bucket" "logs" {
  bucket_prefix = "${var.project}-logs-"
  force_destroy = true # 学習用。本番では false にする
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule {
    id     = "expire-old-logs"
    status = "Enabled"
    filter {}
    expiration {
      days = 90
    }
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

# VPC フローログを S3 に保存し、通信の監査ができるようにする
resource "aws_flow_log" "vpc" {
  vpc_id               = module.network.vpc_id
  traffic_type         = "REJECT"
  log_destination_type = "s3"
  log_destination      = aws_s3_bucket.logs.arn
}

# 想定外の課金を防ぐための月額予算アラート
resource "aws_budgets_budget" "monthly" {
  name         = "${var.project}-monthly"
  budget_type  = "COST"
  limit_amount = tostring(var.budget_limit_usd)
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.alert_email]
  }
}
