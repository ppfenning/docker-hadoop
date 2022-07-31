#!/bin/bash

# install
curl -fSL "$HIVE_URL" -o /tmp/hive-"$HIVE_VERSION".tar.gz
mkdir -p "$HIVE_BASE"
tar -xvf /tmp/hive-"$HIVE_VERSION".tar.gz -C "$HIVE_BASE"
rm /tmp/hive-"$HIVE_VERSION".tar.gz

# properties
sed 's/&#8;/ /' "$HIVE_HOME/conf/hive-default.xml.template" > "$HIVE_HOME/conf/hive-site.xml"
# guava errors
rm -rf "$HIVE_HOME"/lib/guav*.jar || true
cp "$HADOOP_HOME"/share/hadoop/hdfs/lib/guav*.jar "$HIVE_HOME/lib"
# log4j errors
rm -rf "$HIVE_HOME"/lib/*slf4j*.jar || true
