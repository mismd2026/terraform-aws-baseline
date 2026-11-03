variable "project" {
  description = "リソース名の接頭辞に使うプロジェクト名"
  type        = string
  default     = "baseline"
}

variable "region" {
  description = "AWS リージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "VPC の CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "使うアベイラビリティゾーンの数"
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 1 && var.az_count <= 3
    error_message = "az_count は 1〜3 にしてください。"
  }
}

variable "budget_limit_usd" {
  description = "月額予算（USD）。超えそうになると通知する"
  type        = number
  default     = 10
}

variable "alert_email" {
  description = "予算アラートの通知先メールアドレス（terraform.tfvars で指定し、コミットしない）"
  type        = string
}
