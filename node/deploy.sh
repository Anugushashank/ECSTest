#!/bin/bash
SERVICE_NAME=testservice
CLUSTER_NAME=test
BUILD_NUMBER=${CIRCLE_BUILD_NUM}
IMAGE_TAG=${CIRCLE_SHA1}
TASK_FAMILY=ecstest

docker tag ecrtest 878242495038.dkr.ecr.us-east-2.amazonaws.com/ecs_test:$CIRCLE_SHA1
docker tag ecrtest 878242495038.dkr.ecr.us-east-2.amazonaws.com/ecs_test:latest
docker push 878242495038.dkr.ecr.us-east-2.amazonaws.com/ecs_test:$CIRCLE_SHA
docker push 878242495038.dkr.ecr.us-east-2.amazonaws.com/ecs_test:latest

# Create a new task definition for this build
aws ecs register-task-definition  --cli-input-json file://task_definition.json --region us-east-2

# Update the service with the new task definition and desired count
TASK_REVISION=`aws ecs describe-task-definition --task-definition ${TASK_FAMILY} --region us-east-2 | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
DESIRED_COUNT=`aws ecs describe-services --cluster ${CLUSTER_NAME} --services ${SERVICE_NAME} --region us-east-2 | egrep "desiredCount" | head -1 | tr "/" " " | awk '{print $2}' | sed 's/,$//'`
if [ ${DESIRED_COUNT} = "0" ]; then
    DESIRED_COUNT="1"
fi

aws ecs update-service --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${TASK_REVISION} --desired-count 3 --region us-east-2