module "aws-environment" {
    source = "../"
}

resource "aws_ecr_repository" "main" {
  name                 = local.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}