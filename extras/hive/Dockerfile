ARG IMAGE_FAMILY=ppfenning/final-project
ARG TAG=master
FROM ${IMAGE_FAMILY}-base:${TAG}

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

# apache software download source
ENV BASE_URL=https://dlcdn.apache.org

# starter functions
ADD installers/ /installers/
ADD startup/ /startup/
# make executable
RUN chmod a+x /installers/*
RUN chmod a+x /startup/*

# installer hive

# needed for guava error (move before runtime)
ENV HADOOP_VERSION=3.2.4
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
# hive version
ENV HIVE_VERSION=3.1.3
ENV HIVE_URL="$BASE_URL/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz"
# hive location info
ENV HIVE_BASE=/usr/local/hive
ENV HIVE_HOME="$HIVE_BASE/apache-hive-$HIVE_VERSION-bin"
RUN ["/installers/install-hive.sh"]

# install postgres
ENV POSTGRES_URL="https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar"
RUN ["/installers/install-hive-postgres.sh"]

# add config files
ADD conf/ $HIVE_HOME/conf/

# expose ports
EXPOSE 10000
EXPOSE 10002

# update path
ENV PATH=$HIVE_HOME/bin/:$PATH
ENV CLASSPATH=$HADOOP_HOME/lib/:$HIVE_HOME/lib/:$CLASSPATH

CMD ["/startup/start-hive.sh"]
