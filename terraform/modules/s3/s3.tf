#-------------------------------------------------------
#　S3
#-------------------------------------------------------
resource "aws_s3_bucket" "contents_bucket" {
  bucket = "teradacontentsbucket-${var.NameBase}"
}

# resource "aws_s3_bucket_acl" "example" {
#   bucket = aws_s3_bucket.contents_bucket.id
#   acl    = "private"
# }

resource "aws_s3_bucket_versioning" "contents_bucket" {
  bucket = aws_s3_bucket.contents_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}