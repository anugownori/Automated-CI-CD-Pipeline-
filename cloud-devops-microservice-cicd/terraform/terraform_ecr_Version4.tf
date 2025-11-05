resource "aws_ecr_repository" "microservice" {
  name = "cloud-devops-microservice"
  image_tag_mutability = "MUTABLE"
  lifecycle_policy {
    policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire untagged images older than 14 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 14
      },
      "action": {"type": "expire"}
    }
  ]
}
EOF
  }
}