##########################################################################################
### PIG IMAGE
##########################################################################################

ARG IMAGE_FAMILY=ppfenning/final-project
ARG TAG=latest
FROM ${IMAGE_FAMILY}-hive:${TAG}

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

##########################################################################################
### PARAMETERS
##########################################################################################

# apache software download source
ARG BASE_URL
ENV BASE_URL=${BASE_URL:-https://dlcdn.apache.org}
# initialize pig parameters
ARG PIG_VERSION
ENV PIG_VERSION=${PIG_VERSION:-0.17.0}

##########################################################################################
### GET URL
##########################################################################################

ENV PIG_URL=$BASE_URL/pig/pig-$PIG_VERSION/pig-$PIG_VERSION.tar.gz

##########################################################################################
### ADD FILES
##########################################################################################

# installers
ADD installers/ /installers/
RUN chmod a+x /installers/*

##########################################################################################
### PIG
##########################################################################################

# set ENV
ENV PIG_HOME=/usr/lib/pig/pig-$PIG_VERSION
ENV PIG_CLASSPATH=$HADOOP_CONF_DIR
# install
RUN ["/installers/install-pig.sh"]
# update path
ENV PATH=$PIG_HOME/bin/:$PATH
