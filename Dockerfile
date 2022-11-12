FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

ADD https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip /tmp/awscli.zip
ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py

RUN set -e \
      && ln -sf bash /bin/sh \
      && ln -s python3 /usr/bin/python

RUN set -e \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        apt-transport-https ca-certificates curl nodejs python3 \
        python3-distutils unzip \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN set -e \
      && /usr/bin/python3 /tmp/get-pip.py \
      && pip install -U --no-cache-dir pip \
      && pip install -U --no-cache-dir aws-parallelcluster

RUN set -e \
      && cd /tmp \
      && unzip awscli.zip \
      && ./aws/install \
      && rm -f /tmp/awscli.zip

ENTRYPOINT ["/usr/local/bin/pcluster"]
