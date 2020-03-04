# WildRecipe README

## アプリケーションの概要
  WildRecipeは野食専門のレシピ投稿・共有サービスです。

## 機能一覧
  * ユーザー認証[Bcrypt]
  * レシピ投稿[jQueryを利用した可変フォーム]
  * レシピ編集
  * レシピ検索
  * レシピへのコメント
  * レシピのブックマーク
  * レシピのイイネ
  * ページネーション
  * 管理者機能[activeadmin]

## 技術構成
  * データベース
    * MySQL
  * サーバー
    * AWS EC2
    * Nginx
    * Unicorn
  * 画像アップロード
    * CarrierWave
    * Fog-aws
  * 画像ストレージ
    * AWS S3
  * 管理機能
    * Activeadmin