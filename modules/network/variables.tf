variable "name" {
  description = "リソース名の接頭辞"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC の CIDR"
  type        = string
}

variable "azs" {
  description = "サブネットを作るアベイラビリティゾーン"
  type        = list(string)
}
