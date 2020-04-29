#!/usr/bin/env bash

# Prerequisite
# Make sure you set secret enviroment variables in Travis CI
# DOCKER_USERNAME
# DOCKER_PASSWORD
# API_TOKEN

# set -ex

image="alpine/gcloud"

sum=0

latest=$(curl -sL curl https://cloud.google.com/sdk/docs/release-notes |awk -F ">" '/tabindex/{print $2}' |awk '{print $1}' |head -1)
echo "Lastest release is: ${latest}"

tags=`curl -s https://hub.docker.com/v2/repositories/${image}/tags/ |jq -r .results[].name`

for tag in ${tags}
do
  if [ ${tag} == ${latest} ];then
    sum=$((sum+1))
  fi
done

if [[ ( $sum -ne 1 ) || ( ${REBUILD} == "true" ) ]];then
  docker build -t ${image}  --build-arg VERSION=${latest} .
  docker tag ${image} ${image}:${latest}

  if [[ "$TRAVIS_BRANCH" == "master" ]]; then
   docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
   docker push ${image}
   docker push ${image}:${latest}
  fi
fi
