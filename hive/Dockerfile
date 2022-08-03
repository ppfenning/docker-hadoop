##########################################################################################
### HIVE IMAGE
##########################################################################################

ARG IMAGE_FAMILY=ppfenning/docker
ARG BACKEND=hadoop
ARG TAG=master
FROM ${IMAGE_FAMILY}-${BACKEND}:${TAG}

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

##########################################################################################
### PARAMETERS
##########################################################################################

# apache software download source
ARG BASE_URL
ENV BASE_URL=${BASE_URL:-https://dlcdn.apache.org}
# initialize hadoop params
ARG HADOOP_VERSION
ENV HADOOP_VERSION=${HADOOP_VERSION:-3.3.3}
ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
# initialize hive parameters
ARG HIVE_VERSION
ENV HIVE_VERSION=${HIVE_VERSION:-3.1.3}

##########################################################################################
### GET URL
##########################################################################################

ENV HIVE_URL=$BASE_URL/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz

##########################################################################################
### ADD FILES
##########################################################################################

# installers
ADD installers/ /installers/
RUN chmod a+x /installers/*

# startup
ADD startup/ /startup/
RUN chmod a+x /startup/*

##########################################################################################
### HIVE
##########################################################################################

# set ENV
ENV HIVE_BASE=/usr/local/hive
ENV HIVE_HOME="$HIVE_BASE/apache-hive-$HIVE_VERSION-bin"
ENV HIVE_CONF_DIR="$HIVE_HOME/conf"
# install
RUN ["/installers/install-hive.sh"]
# update path
ENV PATH=$HIVE_HOME/bin/:$PATH

##########################################################################################
### CONFIGURATION
##########################################################################################
EXPOSE 10000
RUN ["/startup/start-hive-config.sh"]
RUN useradd -rm -d /home/workerbee -s /bin/bash -g root -G sudo -u 1001 workerbee
ENTRYPOINT ["/startup/start-hive-entrypoint.sh"]
