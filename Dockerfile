FROM jenkins/jenkins:lts
MAINTAINER Harry Lee

USER root

# Install the latest Docker CE binaries
RUN apt-get update && apt-get -y install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common

RUN curl -sSL https://get.docker.com/ | sh

RUN usermod -a -G docker jenkins

# Install latest docker-compose binary
RUN curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install aws-cli
RUN apt-get install -y \
      jq \
      groff \
      python-pip \
      python &&\
    pip install --upgrade \
      pip \
      awscli

USER jenkins

RUN mkdir ~/.aws
VOLUME ["~/.aws"]

RUN /usr/local/bin/install-plugins.sh \
    workflow-aggregator:2.5 \
    git-client:2.7.0 \
    pipeline-multibranch-defaults:1.1 \
    docker-workflow:1.13

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
