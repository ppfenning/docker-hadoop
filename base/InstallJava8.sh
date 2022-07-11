#!/bin/bash
# update existing
apt-get update
# install needed
apt-get install -y --no-install-recommends openjdk-8-jdk \
      net-tools \
      curl \
      netcat \
      gnupg \
      libsnappy-dev \

# remove var files
rm -rf /var/lib/apt/lists/*
