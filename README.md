# gcloud - google cloud command-line tool 

Auto-trigger docker build for [gcloud](https://cloud.google.com/sdk/docs/quickstart-linux) when [new release](https://cloud.google.com/sdk/docs/release-notes) is announced

[![DockerHub Badge](http://dockeri.co/image/alpine/gcloud)](https://hub.docker.com/r/alpine/gcloud/)

## NOTES

All gcloud components are installed, the size of image is quite large (>2.8GB).

The latest docker tag is the latest release version mentioned in https://cloud.google.com/sdk/docs/release-notes

Please avoid to use `latest` tag for any production deployment. Tag with right version is the proper way, such as `alpine/gcloud:290.0.1`

### Github Repo

https://github.com/alpine-docker/gcloud

### Daily Travis CI build logs

https://travis-ci.org/alpine-docker/gcloud

### Docker image tags

https://hub.docker.com/r/alpine/gcloud/tags/

# Usage

Since this container mostly is not running in Google Cloud Shell, so I would recommand to generate credential file and feed to it. 

    $ mkdir -p ~/.config/gcloud
    $ docker run -ti --rm -v ~/.alpine/gcloud:290.0.1 gcloud auth application-default login
    $ cat ~/.config/gcloud/application_default_credentials.json
    {
      "client_id": "764086051850-6qr4p6gpi6hn506pt8ejuq83di341hur.apps.googleusercontent.com",
      "client_secret": "d-FL95Q19q7MQmFpd7hHD0Ty",
      "refresh_token": "1//0gnhgE8nu6YhICgYIARAAGBASNwF-L9IrERjKiLhTFNd_J2kVsvuC6vg0IbF5tl5g7z4NksVp0WEFBvj9KBlMCNmp9iRdImTljoc",
      "type": "authorized_user"
    }

You need run above command one time for each project, the credentials are saved to local host: `~/.config/gcloud/application_default_credentials.json`

Now you are fine to feed it to gcloud container.

    $ docker run -ti --rm -v ~/.config:/root/.config -e GOOGLE_APPLICATION_CREDENTIALS="~/.config/gcloud/application_default_credentials.json" alpine/gcloud:290.0.1 gcloud config list

make above command as alias, so you needn't type them again.

    $ alias gcloud="docker run -ti --rm -v ~/.config:/root/.config -e GOOGLE_APPLICATION_CREDENTIALS="~/.config/gcloud/application_default_credentials.json" alpine/gcloud:290.0.1 gcloud"
    $ gcloud config list
    [accessibility]
    screen_reader = true
    [compute]
    region = us-central1
    zone = us-central1-a
    [core]
    account = student-01-47a98e659643@qwiklabs.net
    disable_usage_reporting = True
    project = qwiklabs-gcp-01-6b02c2d236db

    Your active configuration is: [default]

# Why we need it

Mostly it is used during CI/CD (continuous integration and continuous delivery) or as part of an automated build/deployment

# The Processes to build this image

* Enable Travis CI cronjob on this repo to run build daily on master branch
* Check if there are new tags/releases announced via https://cloud.google.com/sdk/docs/release-notes
* Match the exist docker image tags via Hub.docker.io REST API
* If not matched, build the image with release version and push to https://hub.docker.com/
* Update with latest tag as well
