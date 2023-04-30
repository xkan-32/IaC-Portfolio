#-------------------------------------------------------
# 変数の定義
#-------------------------------------------------------
variable "NameBase" {
  default = "sample01"
  type    = string
}
# 実行環境の管理タグ
variable "env" {
  default = "dev"
  type    = string
}
# VPCのcidr_block
variable "cidr_block_VPC" {
  default = "10.0.0.0/16"
  type    = string
}
# PublicSubnet1aのcidr_block
variable "cidr_block_PublicSubnet1a" {
  default = "10.0.0.0/20"
  type    = string
}
# PublicSubnet1bのcidr_block
variable "cidr_block_PublicSubnet1b" {
  default = "10.0.16.0/20"
  type    = string
}
# PrivateSubnet1aのcidr_block
variable "cidr_block_PrivateSubnet1a" {
  default = "10.0.128.0/20"
  type    = string
}
# PrivateSubnet1bのcidr_block
variable "cidr_block_PrivateSubnet1b" {
  default = "10.0.144.0/20"
  type    = string
}
# Subnet1aのAZ
variable "AZ_1a" {
  default = "ap-northeast-1a"
  type    = string
}
# Subnet1bのAZ
variable "AZ_1b" {
  default = "ap-northeast-1b"
  type    = string
}