#!/bin/bash

# install
curl -fSL "$HIVE_URL" -o /tmp/hive-"$HIVE_VERSION".tar.gz
mkdir /usr/lib/hive/
tar -xvf /tmp/hive-"$HIVE_VERSION".tar.gz -C /usr/lib/hive/
rm /tmp/hive-"$HIVE_VERSION".tar.gz

# hdfs stuff
hdfs dfs -mkdir /tmp
hdfs dfs -chmod g+w /tmp
hdfs dfs -mkdir -p "$HIVE_WH"
hdfs dfs -chmod g+w "$HIVE_WH"

# properties
cp "$HIVE_HOME"/conf/hive-default.xml.template "$HIVE_CONF"
source "/entrypoint.sh"
addProperty "$HIVE_CONF" hive.metastore.warehouse.dir "$HIVE_WH"
# initiate db
$HIVE_HOME/bin/schematool -dbType derby -initSchema
