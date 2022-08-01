##########################################################################################
### HIVE IMAGE
##########################################################################################

ARG IMAGE_FAMILY=ppfenning/final-project
ARG TAG=master
FROM ${IMAGE_FAMILY}-hadoop:${TAG}

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
# install
RUN ["/installers/install-hive.sh"]
# add config files
ADD conf $HIVE_HOME/conf/
# update path
ENV PATH=$HIVE_HOME/bin/:$PATH
ENV CLASSPATH=$HADOOP_HOME/lib/:$HIVE_HOME/lib/:$CLASSPATH

##########################################################################################
### POSTGRES
##########################################################################################

# set ENV
ENV POSTGRES_URL="https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar"
# install
RUN ["/installers/install-hive-postgres.sh"]

##########################################################################################
### PORT EXPORTS
##########################################################################################

EXPOSE 10000
EXPOSE 10002

##########################################################################################
### STARTUP COMMANDS
##########################################################################################

CMD ["/startup/start-hive.sh"]
