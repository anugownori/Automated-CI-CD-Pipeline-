resource "aws_vpc" "main" { cidr_block = "10.16.0.0/16"; tags = { Name = "cloud-devops-vpc" } }
resource "aws_subnet" "public" {
  count = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = { Name = "cloud-devops-public-subnet-${count.index}" }
}
data "aws_availability_zones" "available" {}