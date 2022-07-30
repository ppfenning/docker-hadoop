FROM ubuntu:latest

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

# extras
ENV BASE_URL=https://dlcdn.apache.org
# get install scripts in folder
ADD hadoop/* /installers/hadoop/
# make executable
RUN chmod a+x /installers/hadoop/*

# Install Java
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
# run
RUN ["/installers/hadoop/InstallJava8.sh"]
ENV PATH=$PATH:$JAVA_HOME/bin

# install Hadoop
ENV HADOOP_VERSION=3.2.4
ENV HADOOP_URL="$BASE_URL/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz"
# run
RUN ["/installers/hadoop/InstallHadoop.sh"]

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV USER=root
ENV PATH=$HADOOP_HOME/bin/:$PATH

# get scripts in folder
ADD entrypoint.sh /entrypoint.sh
# make executable
RUN chmod a+x /entrypoint.sh
# run
ENTRYPOINT ["/entrypoint.sh"]
