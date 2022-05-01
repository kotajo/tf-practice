###############
## Main ##
###############
# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail
data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail-s3.id
  # s3_key_prefix                 = "prefix"
  include_global_service_events = true
  is_multi_region_trail = true
}

resource "aws_s3_bucket" "cloudtrail-s3" {
  bucket        = "cloudtrail-${data.aws_caller_identity.current.account_id}"
  force_destroy = false
}

resource "aws_s3_bucket_policy" "cloudtrail-s3" {
  bucket = aws_s3_bucket.cloudtrail-s3.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.cloudtrail-s3.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.cloudtrail-s3.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control",
                    "aws:SourceArn": "arn:aws:cloudtrail:region:${data.aws_caller_identity.current.account_id}:trail/cloudtrail"
                }
            }
        }
    ]
}
POLICY
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail-s3-encryption" {
  bucket = aws_s3_bucket.cloudtrail-s3.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = "aws/s3"
      sse_algorithm     = "aws:kms"
    }
  }
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "cloudtrail-s3_public_access_block" {
  bucket = aws_s3_bucket.cloudtrail-s3.id

  block_public_acls = true
  ignore_public_acls = true
  block_public_policy = true
  restrict_public_buckets = true
}