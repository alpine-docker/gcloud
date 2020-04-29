# gcloud - google cloud command-line tool 

Auto-trigger docker build for [gcloud](https://cloud.google.com/sdk/docs/quickstart-linux) when [new release](https://cloud.google.com/sdk/docs/release-notes) is announced

[![DockerHub Badge](http://dockeri.co/image/alpine/gcloud)](https://hub.docker.com/r/alpine/gcloud/)

## NOTES

The latest docker tag is the latest release version mentioned in https://cloud.google.com/sdk/docs/release-notes

Please avoid to use `latest` tag for any production deployment. Tag with right version is the proper way, such as `alpine/gcloud:290.0.1`

### Github Repo

https://github.com/alpine-docker/gcloud

### Daily Travis CI build logs

https://travis-ci.org/alpine-docker/gcloud

### Docker image tags

https://hub.docker.com/r/alpine/gcloud/tags/

# Usage


# Why we need it

Mostly it is used during CI/CD (continuous integration and continuous delivery) or as part of an automated build/deployment

# The Processes to build this image

* Enable Travis CI cronjob on this repo to run build daily on master branch
* Check if there are new tags/releases announced via https://cloud.google.com/sdk/docs/release-notes
* Match the exist docker image tags via Hub.docker.io REST API
* If not matched, build the image with release version and push to https://hub.docker.com/
* Update with latest tag as well
