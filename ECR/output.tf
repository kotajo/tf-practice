output "ecr-arn" {
  description = "Full ARN of the repository."
  value = aws_ecr_repository.main.arn
}
output "ecr-registry_id" {
  description = "The registry ID where the repository was created."
  value = aws_ecr_repository.main.registry_id
}
output "ecr-repository_url" {
  description = "The URL of the repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)."
  value = aws_ecr_repository.main.repository_url
}