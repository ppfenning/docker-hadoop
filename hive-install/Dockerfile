ARG IMAGE_NAME=ppfenning/hadoop-base:master
FROM ${IMAGE_NAME}

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

ENV BASE_URL=https://dlcdn.apache.org

# installer
ENV HIVE_VERSION=3.1.3
ENV HIVE_URL="$BASE_URL/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz"
# env vars
ENV HIVE_BASE=/usr/local/hive
ENV HIVE_HOME=$HIVE_BASE/apache-hive-$HIVE_VERSION-bin
ENV HIVE_CONF=$HIVE_HOME/conf
ENV HIVE_WH=/user/hive/warehouse
# get scripts in folder
ADD InstallHive.sh /InstallHive.sh
# make executable
RUN chmod a+x /InstallHive.sh
# run
RUN ["/InstallHive.sh"]
# update path
ENV PATH=$PATH:$HIVE_HOME/bin
ENV CLASSPATH=$CLASSPATH:$HADOOP_HOME/lib/*:.
ENV CLASSPATH=$CLASSPATH:$HIVE_HOME/lib/*:.
