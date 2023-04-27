# Infrastructure as Code（IaC）とCI/CDによる自動化
## 背景
* AWSの学習を進める中で、『AWS Well-Architected フレームワークの柱』を意識して、自作のアプリケーションを実装してみたいと思ったからです。
* 以下では、『運用上の優秀性』・『信頼性』を意識して表題を実装しました。
## 全体像
* CircleCIを使用し、GitHubと連携することで、GitHubにpushしたタイミングでJobが走り、インフラ構築、アプリケーションのデプロイなどがすべて自動で実装されます。
## Jobの流れ
1. Terraformにより環境構築(AWS)
    * ポイント
        * moduleを使用
        * 完全自動化する為、後工程で必要なIDなどをoutput
        * for_eachを使い、loop処理させる

2. AnsibleによりEC2にアプリケーションをデプロイ
    * ポイント
        * CircleCIのworkspaceより環境変数を取得
3. カスタムAMIの作成
4. EC2をオートスケーリング
## 各Jobの説明
    