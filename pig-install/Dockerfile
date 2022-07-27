ARG IMAGE_NAME=ppfenning/hadoop-base:master
FROM ${IMAGE_NAME}

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

ENV BASE_URL=https://dlcdn.apache.org
# installer
ENV PIG_VERSION=0.17.0
ENV PIG_URL=$BASE_URL/pig/pig-$PIG_VERSION/pig-$PIG_VERSION.tar.gz
# get scripts in folder
ADD InstallPig.sh /InstallPig.sh
# make executable
RUN chmod a+x /InstallPig.sh
# run
RUN ["/InstallPig.sh"]

# env vars
ENV PIG_HOME=/usr/lib/pig/pig-$PIG_VERSION
ENV PIG_CLASSPATH=$HADOOP_CONF_DIR
ENV PATH=$PATH:$PIG_HOME/bin
