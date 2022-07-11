FROM ubuntu

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

# Install Java
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
# get scripts in folder
ADD InstallJava8.sh /InstallJava8.sh
# make executable
RUN chmod a+x /InstallJava8.sh
# run
RUN ["/InstallJava8.sh"]

# install Hadoop
ENV HADOOP_VERSION 3.2.3
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

# get scripts in folder
ADD InstallHadoop.sh /InstallHadoop.sh
# make executable
RUN chmod a+x /InstallHadoop.sh
# run
RUN ["/InstallHadoop.sh"]

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV USER=root
ENV PATH $HADOOP_HOME/bin/:$PATH

# get scripts in folder
ADD entrypoint.sh /entrypoint.sh
# make executable
RUN chmod a+x /entrypoint.sh
# run
ENTRYPOINT ["/entrypoint.sh"]
