##########################################################################################
### HADOOP IMAGE
##########################################################################################

FROM ubuntu:latest

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

##########################################################################################
### GET URL
##########################################################################################

ENV HADOOP_URL=$BASE_URL/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

##########################################################################################
### ADD FILES
##########################################################################################

# installers
ADD installers/ /installers/
RUN chmod a+x /installers/*

# startup
ADD startup/ /startup/
RUN chmod a+x /startup/*

# functions
ADD functions/ /functions
RUN chmod a+x /functions/*

# entrypount
ADD entrypoint.sh /scripts/
RUN chmod a+x /scripts/entrypoint.sh

##########################################################################################
### JAVA
##########################################################################################

# set ENV
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
# install
RUN ["/installers/install-java8.sh"]
# update path
ENV PATH=$JAVA_HOME/bin/:$PATH

##########################################################################################
### HADOOP
##########################################################################################

# set ENV
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV USER=root
# install
RUN ["/installers/install-hadoop.sh"]
# update path
ENV PATH=$HADOOP_HOME/bin/:$PATH

##########################################################################################
### STARTUP COMMANDS
##########################################################################################

ENTRYPOINT ["/scripts/entrypoint.sh"]
