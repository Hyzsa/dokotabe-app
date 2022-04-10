# 🍴DokoTabe

お近くの飲食店を１店舗すぐに見つけてくれるサービスです。

## URL

⚠️就活が終了したため停止しました。

~~https://dokotabe.com/~~

- ヘッダーの「ログイン」->「ゲストログイン」ボタンから簡易ログインできます。
- 検索機能をご利用する場合は、お手持ちの端末にて「位置情報の利用」を許可しておく必要があります。

## 概要

コンセプトは<b>「飲食店選びを楽にする」</b>です。

- 端末の位置情報から、指定した条件に一致する飲食店を１店舗だけ表示してくれます。
- ログイン中の場合、検索履歴が保存されます。
- 検索履歴からお気に入り登録が可能で、次回来店用にメモしておくことができます。

![DokoTabe-demo](https://user-images.githubusercontent.com/95039317/156915118-9d1e99c5-3e11-4e51-92d0-c46884427e7f.gif)

## 制作理由

職場の先輩方と食事に行く際に、既存の飲食店検索サービスを利用していましたが、  
特に食にこだわりがなかったので、ヒットする多くの選択肢から店舗を選ぶのに労力を使いました。  
そこで最低限の条件にマッチするお店を１店舗だけ表示する Web サービスがあったら便利だなと感じたので制作を決めました。

## 機能一覧

| No  | 実装内容                                                                                                   | Gem/API            |
| --- | ---------------------------------------------------------------------------------------------------------- | ------------------ |
| 1   | アカウント登録・編集機能 <br> メール認証機能 <br> ログイン認証機能 <br> パスワード再設定機能 <br> 退会機能 | devise             |
| 2   | 位置情報取得機能                                                                                           | Geolocation API    |
| 3   | 飲食店検索機能                                                                                             | ホットペッパー API |
| 4   | 検索履歴保存機能                                                                                           |                    |
| 5   | お気に入り登録機能（Ajax）                                                                                 |                    |
| 6   | メモ機能                                                                                                   |                    |

## 使用技術

- 開発環境
  - Docker 20.10.12
  - Docker Compose 2.2.3
- フロントエンド
  - HTML/CSS（Scss）
  - JavaScript（JQuery, Ajax）
  - Bootstrap 5
- バックエンド
  - ruby 2.7.5
  - Ruby on Rails 6.1.4.4
- サーバー
  - Nginx（Web サーバー）
  - Puma（アプリケーションサーバー）
- インフラ
  - AWS（VPC,ECS,ECR,EC2,RDS,Route53,ALB,ACM,SES,IAM）
  - Docker 20.10.7
  - PostgreSQL 14.1
- その他
  - RSpec 3.10
  - factory_bot 6.2.0
  - RuboCop 1.25.0
  - Circle CI（RuboCop / RSpec / デプロイ 自動化）
  - AdobeXD（ワイヤーフレーム）
  - draw.io（ER 図, インフラ構成図）

## インフラ構成図

![Dokotabe_infra drawio](https://user-images.githubusercontent.com/95039317/156913700-63628684-184e-460c-bfb0-83a153537227.png)

## ER 図

![DokoTabe_ER drawio](https://user-images.githubusercontent.com/95039317/156872782-a8365f52-ee1b-46e4-b061-562847c73061.png)

## 追加予定機能

- メモ機能の Ajax 化
- ユーザー管理画面の追加（管理者のみ）
- アクセス数解析ツールの導入

## 著者

[twitter](https://twitter.com/Hyzsa_PG)
