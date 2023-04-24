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
# ALBのサブネット
variable "publicSubnet1a" {}
# ALBのサブネット
variable "publicSubnet1b" {}
# ALBのセキュリティグループ
variable "albsecuritygroup" {}
# ALBのvpc
variable "vpc_id" {}
# ALBのEC2
variable "EC2_1" {}
# ALBのEC2
variable "EC2_2" {}