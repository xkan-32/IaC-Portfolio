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
# インスタンスタイプ
variable "InstanceType" {
  type    = string
  default = "t2.micro"
}
# インスタンスボリュームサイズ
variable "InstanceVolumes" {
  type    = string
  default = "16"
}
# キーペアネーム
variable "key_name" {}
# インスタンスボリュームタイプ
variable "volume_type" {
  type    = string
  default = "gp2"
}
# セキュリティグループの変数
variable "vpc_security_group" {}
# サブネットの変数
variable "publicsubnet1a" {}
# サブネットの変数
variable "publicsubnet1b" {}