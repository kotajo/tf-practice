terraform {
  required_version = ">= 1.1.9"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.13.0"
    }
  }
}

# aws-vault利用
provider "aws" {
    region = var.aws_region
}
