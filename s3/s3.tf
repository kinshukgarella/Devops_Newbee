#provider "aws" {
#  region = var.web_region
#}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.s3_bucket
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}