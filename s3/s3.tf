/*
S3 Bucket Creation Code 
In case, S3 bucket already exist then do not use this code.
Apply the existing S3 bucket name in belo files. 

*/
resource "aws_s3_bucket" "devops-newbee-s3bucket" {
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