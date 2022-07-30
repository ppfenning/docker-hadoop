ARG IMAGE_FAMILY=ppfenning/hadoop
ARG TAG=master
FROM ${IMAGE_FAMILY}-base:${TAG}

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

ADD extras/* /installers/extras/
RUN chmod a+x /installers/extras/*

# installer
ENV PIG_VERSION=0.17.0
ENV PIG_URL=$BASE_URL/pig/pig-$PIG_VERSION/pig-$PIG_VERSION.tar.gz
# run
RUN ["/installers/extras/InstallPig.sh"]

# env vars
ENV PIG_HOME=/usr/lib/pig/pig-$PIG_VERSION
ENV PIG_CLASSPATH=$HADOOP_CONF_DIR
ENV PATH=$PIG_HOME/bin/:$PATH

# installer
ENV HIVE_VERSION=3.1.3
ENV HIVE_URL="$BASE_URL/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz"
# env vars
ENV HIVE_BASE=/usr/local/hive
ENV HIVE_HOME="$HIVE_BASE/apache-hive-$HIVE_VERSION-bin"
# run
RUN ["/installers/extras/InstallHive.sh"]
# update path
ENV PATH=$HIVE_HOME/bin/:$PATH
ENV CLASSPATH=$CLASSPATH:$HADOOP_HOME/lib/*:$HIVE_HOME/lib/*:.

# initialize hive with derby
CMD ["schematool -dbType derby -initSchema"]
