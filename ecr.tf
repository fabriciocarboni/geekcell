/*
 * ecr.tf
 * Creates a Amazon Elastic Container Registry (ECR) for the application
 */

 
resource "aws_ecr_repository" "ecr_repo" {
  name                 = "demo-nginx-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

output "REPOSITORY_URL" {
  description = "The URL of the repository."
  value       = aws_ecr_repository.ecr_repo.repository_url
}