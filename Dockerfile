FROM python:3-alpine

# variable "VERSION" must be passed as docker environment variables during the image build

ARG VERSION=290.0.1

ENV GCLOUD_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${VERSION}-linux-x86_64.tar.gz"
ENV CLOUD_SQL_PROXY="https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64"

RUN apk add --update --no-cache curl ca-certificates bash && \
    curl -L ${GCLOUD_URL} |tar xvz && \
    /google-cloud-sdk/install.sh -q

SHELL ["/bin/bash", "-c"]

RUN source /google-cloud-sdk/completion.bash.inc && \
    source /google-cloud-sdk/path.bash.inc && \
    echo "source /google-cloud-sdk/completion.bash.inc" >> ~/.bashrc && \
    echo "source /google-cloud-sdk/path.bash.inc" >> ~/.bashrc

ENV PATH="/google-cloud-sdk/bin:${PATH}"

RUN gcloud components list |grep "Not Installed" |while read line; do echo $line | awk -F "│" '{print $4}' ; done |while read component ; do gcloud components install ${component} -q ; done

WORKDIR /apps

