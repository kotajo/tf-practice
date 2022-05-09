module "aws-environment" {
    source = "../"
}

module "network" {
    source = "../network/"
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "api-server" {
  name        = local.api-server-name
  description = "for api server"
  vpc_id      = module.network.vpc-id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.api-server-name
  }
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "backend-alb" {
  name               = local.backend-alb-name
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.backend-alb.id]
  subnets            = [
    module.network.subnet-private01-id,
    module.network.subnet-private02-id,
    module.network.subnet-private03-id
  ]

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.alb-log.bucket
    prefix = local.backend-alb-name
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_security_group" "backend-alb" {
  name        = local.backend-alb-sg-name
  description = "for backend alb"
  vpc_id      = module.network.vpc-id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.backend-alb-sg-name
  }
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
resource "aws_security_group_rule" "http-from-application" {
  type             = "ingress"
  description      = "HTTP Access from application server"
  from_port        = var.http-port
  to_port          = var.http-port
  protocol         = "tcp"
  source_security_group_id = aws_security_group.api-server.id
  security_group_id = aws_security_group.backend-alb.id
}

resource "aws_security_group_rule" "http-from-management" {
  type             = "ingress"
  description      = "HTTP Access from management subnet"
  from_port        = var.http-port
  to_port          = var.http-port
  protocol         = "tcp"
  cidr_blocks      = [var.management-subnets-cidr]
  security_group_id = aws_security_group.backend-alb.id
}

resource "aws_security_group_rule" "test-http-from-management" {
  type             = "ingress"
  description      = "test HTTP Access from management subnet"
  from_port        = var.test-http-port
  to_port          = var.test-http-port
  protocol         = "tcp"
  cidr_blocks      = [var.management-subnets-cidr]
  security_group_id = aws_security_group.backend-alb.id
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account
data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "alb-log" {
  bucket        = "${local.backend-alb-name}-log-${data.aws_caller_identity.current.account_id}"
  force_destroy = false
}

resource "aws_s3_bucket_policy" "alb-log" {
  bucket = aws_s3_bucket.alb-log.id
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.alb-log.arn}/AWSLogs/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "alb-log" {
  bucket = aws_s3_bucket.alb-log.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = "aws/s3"
      sse_algorithm     = "aws:kms"
    }
  }
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "alb-log" {
  bucket = aws_s3_bucket.alb-log.id

  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration
resource "aws_s3_bucket_lifecycle_configuration" "alb-log" {
  bucket = aws_s3_bucket.alb-log.id

  rule {
    id = "rule-1"
    filter {}
    transition {
      storage_class = "INTELLIGENT_TIERING"
    }

    status = "Enabled"
  }
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls
resource "aws_s3_bucket_ownership_controls" "alb-log" {
  bucket = aws_s3_bucket.alb-log.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "backend-alb-tg-blue" {
  name        = "${local.backend-alb-tg-name}-blue"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.network.vpc-id
}

resource "aws_lb_target_group" "backend-alb-tg-green" {
  name        = "${local.backend-alb-tg-name}-green"
  port        = 10080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.network.vpc-id
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "backend-alb" {
  load_balancer_arn = aws_lb.backend-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend-alb-tg-blue.arn
  }
}

resource "aws_lb_listener" "backend-alb-test" {
  load_balancer_arn = aws_lb.backend-alb.arn
  port              = "10080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend-alb-tg-green.arn
  }
}