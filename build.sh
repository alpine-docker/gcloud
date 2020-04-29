#!/usr/bin/env bash

# Prerequisite
# Make sure you set secret enviroment variables in Travis CI
# DOCKER_USERNAME
# DOCKER_PASSWORD
# API_TOKEN

# set -ex

image="alpine/gcloud"

latest=$(curl -sL curl https://cloud.google.com/sdk/docs/release-notes |awk -F ">" '/tabindex/{print $2}' |awk '{print $1}' |head -1)
echo $latest

docker build -t ${image}  --build-arg VERSION=${latest} .
docker tag ${image} ${image}:${latest}

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
 docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
 docker push ${image}
 docker push ${image}:${latest}
fi

