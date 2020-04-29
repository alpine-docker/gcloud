#!/usr/bin/env bash

# Prerequisite
# Make sure you set secret enviroment variables in Travis CI
# DOCKER_USERNAME
# DOCKER_PASSWORD
# API_TOKEN

# set -ex

image="alpine/gcloud"

docker build -t ${image} .

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
 docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
 docker push ${image}
fi

