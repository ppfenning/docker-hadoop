FROM ubuntu:latest

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

##########################################################################################
### VANILLA HADOOP INSTALL
##########################################################################################

# apache software download source
ENV BASE_URL=https://dlcdn.apache.org
# get install scripts in folder
ADD hadoop/ /installers/hadoop/
# make executable
RUN chmod a+x /installers/hadoop/*

# Install Java
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
# run
RUN ["/installers/hadoop/InstallJava8.sh"]
ENV PATH=$JAVA_HOME/bin/:$PATH

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

# add startup scripts
ADD startup/ /startup/
# make executable
RUN chmod a+x /startup/*

# add helper functions to folder
ADD functions/ /functions
# make executable
RUN chmod a+x /functions

# get scripts in folder
ADD entrypoint.sh /scripts/
# make executable
RUN chmod a+x /scripts/entrypoint.sh
# run
ENTRYPOINT ["/scripts/entrypoint.sh"]
