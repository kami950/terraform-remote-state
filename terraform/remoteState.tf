resource "aws_s3_bucket" "state_bucket" {
  bucket = lower("${var.STAGE}-terraform-remote-state")
}

resource "aws_kms_key" "state_bucket_kms_key" {
  description             = "This key is used to encrypt remote state bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket_encryption_config" {
  bucket = aws_s3_bucket.state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.state_bucket_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  bucket = aws_s3_bucket.state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_account_public_access_block" "state_bucket_public_lock" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_state_locking_table" {
  name         = lower("${var.STAGE}-terraform-remote-state-locking-table")
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
