variable "aws_region" { description = "AWS region"; type = string; default = "ap-south-1" }
variable "app_name"   { description = "Microservice app name"; type = string; default = "cloud-devops-microservice" }
variable "image_tag"  { description = "Docker image tag"; type = string; default = "latest" }