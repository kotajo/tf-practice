### VPC ###
output "vpc-id" {
  description = "The ID of the VPC"
  value = aws_vpc.main.id
}
output "vpc-arn" {
  description = "Amazon Resource Name (ARN) of VPC"
  value = aws_vpc.main.arn
}

### Subnet ###
output "subnet-public01-id" {
  description = "The ID of the subnet"
  value = aws_subnet.public01.id
}
output "subnet-public01-arn" {
  description = "The ARN of the subnet"
  value = aws_subnet.public01.arn
}

output "subnet-public02-id" {
  description = "The ID of the subnet"
  value = aws_subnet.public02.id
}
output "subnet-public02-arn" {
  description = "The ARN of the subnet"
  value = aws_subnet.public02.arn
}

output "subnet-public03-id" {
  description = "The ID of the subnet"
  value = aws_subnet.public03.id
}
output "subnet-public03-arn" {
  description = "The ARN of the subnet"
  value = aws_subnet.public03.arn
}

output "subnet-private01-id" {
  description = "The ID of the subnet"
  value = aws_subnet.private01.id
}
output "subnet-private01-arn" {
  description = "The ARN of the subnet"
  value = aws_subnet.private01.arn
}

output "subnet-private02-id" {
  description = "The ID of the subnet"
  value = aws_subnet.private02.id
}
output "subnet-private02-arn" {
  description = "The ARN of the subnet"
  value = aws_subnet.private02.arn
}

output "subnet-private03-id" {
  description = "The ID of the subnet"
  value = aws_subnet.private03.id
}
output "subnet-private03-arn" {
  description = "The ARN of the subnet"
  value = aws_subnet.private03.arn
}

output "subnet-db01-id" {
  description = "The ID of the subnet"
  value = aws_subnet.db01.id
}
output "subnet-db01-arn" {
  description = "The ARN of the subnet"
  value = aws_subnet.db01.arn
}

output "subnet-db02-id" {
  description = "The ID of the subnet"
  value = aws_subnet.db02.id
}
output "subnet-db02-arn" {
  description = "The ARN of the subnet"
  value = aws_subnet.db02.arn
}

output "subnet-db03-id" {
  description = "The ID of the subnet"
  value = aws_subnet.db03.id
}
output "subnet-db03-arn" {
  description = "The ARN of the subnet"
  value = aws_subnet.db03.arn
}

output "subnet-maintenance01-id" {
  description = "The ID of the subnet"
  value = aws_subnet.maintenance01.id
}
output "subnet-maintenance01-arn" {
  description = "The ARN of the subnet"
  value = aws_subnet.maintenance01.arn
}

output "subnet-maintenance02-id" {
  description = "The ID of the subnet"
  value = aws_subnet.maintenance02.id
}
output "subnet-maintenance02-arn" {
  description = "The ARN of the subnet"
  value = aws_subnet.maintenance02.arn
}

output "subnet-maintenance03-id" {
  description = "The ID of the subnet"
  value = aws_subnet.maintenance03.id
}
output "subnet-maintenance03-arn" {
  description = "The ARN of the subnet"
  value = aws_subnet.maintenance03.arn
}