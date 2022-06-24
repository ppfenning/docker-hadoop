FROM ubuntu:latest

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      openjdk-8-jdk \
      net-tools \
      curl \
      netcat \
      gnupg \
      libsnappy-dev \
    && rm -rf /var/lib/apt/lists/*
      
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

ADD *.sh /
RUN chmod a+x /*.sh
RUN ["/install-hadoop.sh"]
ENTRYPOINT ["/entrypoint.sh"]
