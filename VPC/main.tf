module "aws-environment" {
    source = "../"
}

### VPC ###
# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block       = "${lookup(local.vpc, "cidr")}"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${lookup(local.vpc, "name")}"
  }
}

### VPC Flowlog ###
# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log
resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.flowlog.arn
  log_destination = aws_cloudwatch_log_group.flowlog.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

resource "aws_cloudwatch_log_group" "flowlog" {
  name = "flowlog-${lookup(local.vpc, "name")}"
  retention_in_days = 7
}

resource "aws_iam_role" "flowlog" {
  name = "FlowlogRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "flowlog" {
  name = "FlowlogPolicy"
  path = "/"
  description = "VPC Flowlogs to Cloudwatch logs"  

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "flowlog" {
  role      = aws_iam_role.flowlog.name
  policy_arn = aws_iam_policy.flowlog.arn
}

### Internet Gateway ###
# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-${var.system-name}"
  }
}

### Nat Gateways ###
# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "nat-gw-a" {
  vpc      = true

  tags = {
    Name = "ngw-${var.system-name}-a"
  }
}

# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "az-a" {
  allocation_id = aws_eip.nat-gw-a.id
  subnet_id     = aws_subnet.public01.id

  tags = {
    Name = "ngw-${var.system-name}-a"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_eip" "nat-gw-c" {
  vpc      = true

  tags = {
    Name = "ngw-${var.system-name}-c"
  }
}

resource "aws_nat_gateway" "az-c" {
  allocation_id = aws_eip.nat-gw-c.id
  subnet_id     = aws_subnet.public01.id

  tags = {
    Name = "ngw-${var.system-name}-c"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_eip" "nat-gw-d" {
  vpc      = true

  tags = {
    Name = "ngw-${var.system-name}-d"
  }
}

resource "aws_nat_gateway" "az-d" {
  allocation_id = aws_eip.nat-gw-d.id
  subnet_id     = aws_subnet.public01.id

  tags = {
    Name = "ngw-${var.system-name}-d"
  }

  depends_on = [aws_internet_gateway.main]
}

### VPC Endpoints ###
# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  tags = {
    Name = "s3-endpoint-${var.system-name}"
  }
}

### Subnets ###
# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "public01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${lookup(local.public-subnet01, "cidr")}"
  availability_zone = "${lookup(local.public-subnet01, "az")}"

  tags = {
    Name = "${lookup(local.public-subnet01, "name")}"
  }
}

resource "aws_subnet" "public02" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${lookup(local.public-subnet02, "cidr")}"
  availability_zone = "${lookup(local.public-subnet02, "az")}"

  tags = {
    Name = "${lookup(local.public-subnet02, "name")}"
  }
}

resource "aws_subnet" "public03" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${lookup(local.public-subnet03, "cidr")}"
  availability_zone = "${lookup(local.public-subnet03, "az")}"

  tags = {
    Name = "${lookup(local.public-subnet03, "name")}"
  }
}

resource "aws_subnet" "private01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${lookup(local.private-subnet01, "cidr")}"
  availability_zone = "${lookup(local.private-subnet01, "az")}"

  tags = {
    Name = "${lookup(local.private-subnet01, "name")}"
  }
}

resource "aws_subnet" "private02" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${lookup(local.private-subnet02, "cidr")}"
  availability_zone = "${lookup(local.private-subnet02, "az")}"

  tags = {
    Name = "${lookup(local.private-subnet02, "name")}"
  }
}

resource "aws_subnet" "private03" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${lookup(local.private-subnet03, "cidr")}"
  availability_zone = "${lookup(local.private-subnet03, "az")}"

  tags = {
    Name = "${lookup(local.private-subnet03, "name")}"
  }
}

resource "aws_subnet" "db01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${lookup(local.db-subnet01, "cidr")}"
  availability_zone = "${lookup(local.db-subnet01, "az")}"

  tags = {
    Name = "${lookup(local.db-subnet01, "name")}"
  }
}

resource "aws_subnet" "db02" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${lookup(local.db-subnet02, "cidr")}"
  availability_zone = "${lookup(local.db-subnet02, "az")}"

  tags = {
    Name = "${lookup(local.db-subnet02, "name")}"
  }
}

resource "aws_subnet" "db03" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${lookup(local.db-subnet03, "cidr")}"
  availability_zone = "${lookup(local.db-subnet03, "az")}"

  tags = {
    Name = "${lookup(local.db-subnet03, "name")}"
  }
}

### Route Tables ###
# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.system-name}-public"
  }
}

resource "aws_route_table" "private-a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.az-a.id
  }

  tags = {
    Name = "${var.system-name}-private-a"
  }
}

resource "aws_route_table" "private-c" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.az-c.id
  }

  tags = {
    Name = "${var.system-name}-private-c"
  }
}

resource "aws_route_table" "private-d" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.az-d.id
  }

  tags = {
    Name = "${var.system-name}-private-d"
  }
}

### VPC Endpoint Route Table association ###
resource "aws_vpc_endpoint_route_table_association" "public" {
  route_table_id  = aws_route_table.public.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "private-a" {
  route_table_id  = aws_route_table.private-a.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "private-c" {
  route_table_id  = aws_route_table.private-c.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "private-d" {
  route_table_id  = aws_route_table.private-d.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

### Route Table Association ###
# Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "public01" {
  subnet_id      = aws_subnet.public01.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public02" {
  subnet_id      = aws_subnet.public02.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public03" {
  subnet_id      = aws_subnet.public03.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private01" {
  subnet_id      = aws_subnet.private01.id
  route_table_id = aws_route_table.private-a.id
}

resource "aws_route_table_association" "private02" {
  subnet_id      = aws_subnet.private02.id
  route_table_id = aws_route_table.private-c.id
}

resource "aws_route_table_association" "private03" {
  subnet_id      = aws_subnet.private03.id
  route_table_id = aws_route_table.private-d.id
}

resource "aws_route_table_association" "db01" {
  subnet_id      = aws_subnet.db01.id
  route_table_id = aws_route_table.private-a.id
}

resource "aws_route_table_association" "db02" {
  subnet_id      = aws_subnet.db02.id
  route_table_id = aws_route_table.private-c.id
}

resource "aws_route_table_association" "db03" {
  subnet_id      = aws_subnet.db03.id
  route_table_id = aws_route_table.private-d.id
}