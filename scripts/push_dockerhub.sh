#!/bin/bash

if [ $BRANCH_NAME -eq "master" ]; then
  $VERSION="latest"
else
  $VERSION=$BRANCH_NAME
fi

docker login --username=drecomdockerhub --password=$$DOCKERHUB_PASSWORD
docker tag gcr.io/$PROJECT_ID/$REPO_NAME:$COMMIT_SHA drecom/centos-ruby:$VERSION
docker push drecom/centos-ruby:$VERSION
