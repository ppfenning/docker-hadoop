#!/bin/bash

# update existing
apt-get update
# install needed
apt-get install -y --no-install-recommends default-jdk scala git

# verify installs
java -version; javac -version; scala -version; git --version

# download
curl -fSL "$SPARK_URL" -o /tmp/spark-"$SPARK_VERSION".tar.gz
tar -xvf /tmp/spark-"$SPARK_VERSION".tar.gz -C /tmp
sudo mv /tmp/spark-"$SPARK_VERSION" /opt/spark
rm /tmp/spark-"$SPARK_VERSION".tar.gz
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# start spark
start-master.sh
# because datanode count is not know until after startup, workers will be started after compose is complete
