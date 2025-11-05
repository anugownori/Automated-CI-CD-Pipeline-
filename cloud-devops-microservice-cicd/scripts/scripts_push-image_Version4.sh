#!/usr/bin/env bash
# Usage: ./push-image.sh <image_tag>
set -e
REGION="ap-south-1"
REPO="cloud-devops-microservice"
IMAGE_TAG=${1:-latest}
ACCOUNT_ID='123456789012' # <-- Replace with your actual AWS Account ID

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
docker build -t $REPO:$IMAGE_TAG app/
docker tag $REPO:$IMAGE_TAG ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/$REPO:$IMAGE_TAG
docker push ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/$REPO:$IMAGE_TAG