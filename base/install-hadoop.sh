#!/bin/bash
HADOOP_VERSION=3.3.3
HADOOP_URL="https://www.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"

curl -fSL "${HADOOP_URL}" -o /tmp/hadoop.tar.gz
tar -xvf /tmp/hadoop.tar.gz -C /opt/
rm /tmp/hadoop.tar.gz
ln -s "/opt/hadoop-${HADOOP_VERSION}/etc/hadoop" /etc/hadoop
mkdir "/opt/hadoop-${HADOOP_VERSION}/logs"
mkdir /hadoop-data

export HADOOP_HOME="/opt/hadoop-${HADOOP_VERSION}"
export HADOOP_CONF_DIR=/etc/hadoop
export MULTIHOMED_NETWORK=1
export USER=root
export PATH="${HADOOP_HOME}/bin/:${PATH}"
