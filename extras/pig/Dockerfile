ARG IMAGE_FAMILY=ppfenning/final-project
ARG TAG=latest
FROM ${IMAGE_FAMILY}-hive:${TAG}

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

ENV BASE_URL=https://dlcdn.apache.org
# starter functions
ADD installers/ /installers/
RUN chmod a+x /installers/*

# installer
ENV PIG_VERSION=0.17.0
ENV PIG_URL=$BASE_URL/pig/pig-$PIG_VERSION/pig-$PIG_VERSION.tar.gz
# run
RUN ["/installers/install-pig.sh"]

# env vars
ENV PIG_HOME=/usr/lib/pig/pig-$PIG_VERSION
ENV PIG_CLASSPATH=$HADOOP_CONF_DIR
ENV PATH=$PIG_HOME/bin/:$PATH
