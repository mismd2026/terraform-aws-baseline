terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # チームで使う場合は state を S3 に置く（use_lockfile は Terraform 1.10 以降）。最初はローカル state で試し、
  # 作成した S3 バケット名を入れてからコメントを外して `terraform init -migrate-state` する。
  # backend "s3" {
  #   bucket       = "<state用バケット名>"
  #   key          = "baseline/terraform.tfstate"
  #   region       = "ap-northeast-1"
  #   use_lockfile = true
  #   encrypt      = true
  # }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project   = var.project
      ManagedBy = "terraform"
    }
  }
}
