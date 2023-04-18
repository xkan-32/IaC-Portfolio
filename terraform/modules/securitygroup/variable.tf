#-------------------------------------------------------
# 変数の定義
#-------------------------------------------------------
variable "NameBase" {
  type    = string
  default = "sample01"
}
# 実行環境の管理タグ
variable "env" {
  default = "dev"
  type    = string
}
# VPCのidの変数
variable "vpc_id" {}