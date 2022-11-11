FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py
ADD https://raw.githubusercontent.com/dceoy/print-github-tags/master/print-github-tags /usr/local/bin/print-github-tags

RUN set -e \
      && ln -sf bash /bin/sh \
      && ln -s python3 /usr/bin/python

RUN set -e \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        apt-transport-https ca-certificates curl python3 python3-distutils \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN set -e \
      && /usr/bin/python3 /tmp/get-pip.py \
      && pip install -U --no-cache-dir pip \
      && pip install -U --no-cache-dir aws-parallelcluster

RUN set -eo pipefail \
      && chmod +x /usr/local/bin/print-github-tags \
      && print-github-tags --release --latest nvm-sh/nvm \
        | xargs -I{} curl -SL -o - \
          https://raw.githubusercontent.com/nvm-sh/nvm/{}/install.sh \
        | bash \
      && chmod ug+x ~/.nvm/nvm.sh \
      && source ~/.nvm/nvm.sh \
      && nvm install --lts \
      && node --version

ENTRYPOINT ["/usr/local/bin/pcluster"]
