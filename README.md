# Infrastructure as Code（IaC）とCI/CDによる自動化
## 背景
* AWSの学習を進める中で、『AWS Well-Architected フレームワークの柱』を意識して、自作のアプリケーションを実装してみたいと思ったからです。
* 以下では、『運用上の優秀性』・『信頼性』を意識して表題を実装しました。
---------
## 全体像
* CircleCIを使用し、GitHubと連携することで、GitHubにpushしたタイミングでJobが走り、インフラ構築、アプリケーションのデプロイなど、すべて自動で実装されます。
* CircleCIではRDSの認証情報、IAMの情報、E-mailアドレスを環境変数として登録しています。
* Job間で連携する為、workspace使用しています。
### Jobの流れ
1. Terraformを使用し、環境構築(AWS)
    * ポイント
        * moduleを使用
        * 完全自動化する為、後工程で必要なIDなどをoutput
        * for_eachを使い、loop処理させる

2. Ansibleを使用し、EC2にアプリケーションをデプロイ
    * ポイント
        * CircleCIのworkspaceより環境変数を取得
        * 環境変数はTerraformのoutputをtxt保存したものを使用
3. AWS CLIを使用し、カスタムAMIの作成
    * ポイント
        * デプロイしたEC2からAWSCLIでカスタムIAMを作成
        * EC2のIDは、Terraformのoutputから取得
4. CloudFormationを使用し、EC2をオートスケーリング
    * ポイント
        * カスタムAMIを使用しオートスケーリングを実装
        * EC2のCPU使用率に対して、CloudWatchアラームを設定し、EC2のスケールイン・アウトを実行
        * アラーム時にSNSを使用しE-mail通知
--------

## Infrastructureについて
* AWSに環境を構築するにあたり、最小構成・信頼性を意識し、運用上の優秀性としてコード化を実施しました。
    * EC2・・マルチAZ構成を基本として、オートスケーリング
    * RDS・・マルチAZ構成
    * CloudWatch・・アラームを設定し、オートスケーリングのトリガーとして設定、E-mail通知

* インフラ構成図
![インフラ構成図](image/%E3%82%A4%E3%83%B3%E3%83%95%E3%83%A9%E6%A7%8B%E6%88%90%E5%9B%B3.svg)
-------
## アプリケーションについて
* Flask・Uwsgi・Nginxを使用したアプリケーションです。[自作アプリケーション](https://github.com/xkan-32/sample-app)
* 動作の様子
![app](https://user-images.githubusercontent.com/121345057/235046195-a7f71d74-49fe-4928-b54f-9b0c7e11d036.gif)
------
## 動作の確認