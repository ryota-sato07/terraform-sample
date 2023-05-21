/**
 * プライベートバケットの定義
 */
resource "aws_s3_bucket" "private" {
  # 世界で一意となるバケット名にする
  bucket = "private-bucket-terraform-sample"

  # バージョニング
  versioning {
    enabled = true
  }

  # 暗号化を有効化
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

/**
 * ブロックパブリックアクセスの定義
 */
resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

/**
 * ログバケットの定義
 */
resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-bucket-terraform-sample-test"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "30"
    }
  }
}

/**
 * バケットポリシーの定義
 */
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

# 環境変数用の定義
variable "aws_account_id" {}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.aws_account_id]
    }
  }
}