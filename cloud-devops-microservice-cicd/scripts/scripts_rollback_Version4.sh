#!/usr/bin/env bash
set -e
REGION="ap-south-1"
CLUSTER="cloud-devops-ecs-cluster"
SERVICE="cloud-devops-microservice-svc"

LAST_TASK_DEF=$(aws ecs describe-services --cluster $CLUSTER --services $SERVICE --region $REGION --query 'services[0].taskDefinition' --output text)
aws ecs update-service --cluster $CLUSTER --service $SERVICE --task-definition $LAST_TASK_DEF --region $REGION