output "alb_dns" { value = aws_lb.microservice.dns_name; description = "ALB DNS" }
output "ecr_repo_url" { value = aws_ecr_repository.microservice.repository_url; description = "ECR repo URI" }