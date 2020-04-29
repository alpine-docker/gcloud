# gcloud - google cloud command-line tool 

Auto-trigger docker build for [gcloud](https://cloud.google.com/sdk/docs/quickstart-linux) when [new release](https://cloud.google.com/sdk/docs/release-notes) is announced

[![DockerHub Badge](http://dockeri.co/image/alpine/gcloud)](https://hub.docker.com/r/alpine/gcloud/)

┌────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                 Components                                                 │
├───────────────┬──────────────────────────────────────────────────────┬──────────────────────────┬──────────┤
│     Status    │                         Name                         │            ID            │   Size   │
├───────────────┼──────────────────────────────────────────────────────┼──────────────────────────┼──────────┤
│ Installed     │ App Engine Go Extensions                             │ app-engine-go            │  4.9 MiB │
│ Installed     │ Appctl                                               │ appctl                   │ 20.1 MiB │
│ Installed     │ Cloud Bigtable Command Line Tool                     │ cbt                      │  7.7 MiB │
│ Installed     │ Cloud Bigtable Emulator                              │ bigtable                 │  6.6 MiB │
│ Installed     │ Cloud Datalab Command Line Tool                      │ datalab                  │  < 1 MiB │
│ Installed     │ Cloud Datastore Emulator                             │ cloud-datastore-emulator │ 18.4 MiB │
│ Installed     │ Cloud Firestore Emulator                             │ cloud-firestore-emulator │ 40.4 MiB │
│ Installed     │ Cloud Pub/Sub Emulator                               │ pubsub-emulator          │ 34.9 MiB │
│ Installed     │ Cloud SQL Proxy                                      │ cloud_sql_proxy          │  3.8 MiB │
│ Installed     │ Cloud Spanner Emulator                               │ cloud-spanner-emulator   │ 21.3 MiB │
│ Installed     │ Emulator Reverse Proxy                               │ emulator-reverse-proxy   │ 14.5 MiB │
│ Installed     │ Google Cloud Build Local Builder                     │ cloud-build-local        │  6.0 MiB │
│ Installed     │ Google Container Registry's Docker credential helper │ docker-credential-gcr    │  1.8 MiB │
│ Installed     │ Kind                                                 │ kind                     │  4.5 MiB │
│ Installed     │ Minikube                                             │ minikube                 │ 22.1 MiB │
│ Installed     │ Skaffold                                             │ skaffold                 │ 12.0 MiB │
│ Installed     │ anthos-auth                                          │ anthos-auth              │  8.7 MiB │
│ Installed     │ gcloud Alpha Commands                                │ alpha                    │  < 1 MiB │
│ Installed     │ gcloud Beta Commands                                 │ beta                     │  < 1 MiB │
│ Installed     │ gcloud app Java Extensions                           │ app-engine-java          │ 62.3 MiB │
│ Installed     │ gcloud app PHP Extensions                            │ app-engine-php           │          │
│ Installed     │ gcloud app Python Extensions                         │ app-engine-python        │  6.1 MiB │
│ Installed     │ gcloud app Python Extensions (Extra Libraries)       │ app-engine-python-extras │ 27.1 MiB │
│ Installed     │ kpt                                                  │ kpt                      │ 19.6 MiB │
│ Installed     │ kubectl                                              │ kubectl                  │  < 1 MiB │
│ Installed     │ BigQuery Command Line Tool                           │ bq                       │  < 1 MiB │
│ Installed     │ Cloud SDK Core Libraries                             │ core                     │ 14.3 MiB │
│ Installed     │ Cloud Storage Command Line Tool                      │ gsutil                   │  3.6 MiB │
└───────────────┴──────────────────────────────────────────────────────┴──────────────────────────┴──────────┘

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

Since this container mostly is not running in Google Cloud Shell, so I would recommand to generate credential file and feed to it. 

    mkdir -p ~/.config/gcloud
    docker run -ti --rm -v ~/.alpine/gcloud:290.0.1 gcloud auth application-default login

You need run above command one time, and will generate a json file with full path

For example, the credentials are saved to local host: `~/.config/gcloud/application_default_credentials.json`

Now you are fine to feed it to the container.

    docker run -ti --rm -v ~/.config:/root/.config -e GOOGLE_APPLICATION_CREDENTIALS="~/.config/gcloud/application_default_credentials.json" alpine/gcloud:290.0.1 gcloud config list

make above command as alias, so you needn't type them again.

    alias gcloud="docker run -ti --rm -v ~/.config:/root/.config -e GOOGLE_APPLICATION_CREDENTIALS="~/.config/gcloud/application_default_credentials.json" alpine/gcloud:290.0.1 gcloud" 
    gcloud config list

# Why we need it

Mostly it is used during CI/CD (continuous integration and continuous delivery) or as part of an automated build/deployment

# The Processes to build this image

* Enable Travis CI cronjob on this repo to run build daily on master branch
* Check if there are new tags/releases announced via https://cloud.google.com/sdk/docs/release-notes
* Match the exist docker image tags via Hub.docker.io REST API
* If not matched, build the image with release version and push to https://hub.docker.com/
* Update with latest tag as well
