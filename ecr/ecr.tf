terraform {
  backend "s3" {
    bucket = var.s3_bucket
    key    = "ecr-terraform.tfstate"
    region = var.web_region
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
resource "aws_ecr_repository" "kinshukdevops-ecr-repo" {
  name                 = var.repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}