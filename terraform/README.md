## 概要

TerraformとGitHub Actionsを用いて、AWSにEC2をメインとしたLAMP環境を構築。

---

## 使用技術

- **IaC**: Terraform
- **CI/CD**: GitHub Actions
- **CMS**: WordPress
- **その他**:
  - VPC
  - EC2
  - ACM
  - CloudFront
    - キャッシュサーバ、SSLアクセラレーターとして使用
  - S3
    - uploadsの格納先として使用
    - CloudFrontと合わせて静的コンテンツとして配信し、プラグイン連携

---

## 主要ミドルウェア
Apache
MySQL
PHP

## 構成
- メイン
Internet -> CloudFront -> EC2

- データ
Internet -> CloudFront -> S3