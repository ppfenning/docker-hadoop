#!/bin/bash

# install
curl -fSL "$HIVE_URL" -o /tmp/hive-"$HIVE_VERSION".tar.gz
mkdir -p "$HIVE_BASE"
tar -xvf /tmp/hive-"$HIVE_VERSION".tar.gz -C "$HIVE_BASE"
rm /tmp/hive-"$HIVE_VERSION".tar.gz

function mkdirHadoop() {
  local newdir=$1

  hadoop fs -test -d "$newdir";

  if [ $? -eq 1 ]
  then
      hdfs dfs -mkdir -p "$newdir"
  fi
  hdfs dfs -chmod a+w "$newdir"
}

mkdirHadoop /tmp/hive
mkdirHadoop "$HIVE_WH"

function addProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="<property><name>$name</name><value>${value}</value></property>"
  local escapedEntry=$(echo "$entry" | sed 's/\//\\\//g')
  sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" "$path"
}

# properties
sed 's/&#8;/ /' "$HIVE_CONF/hive-default.xml.template" > "$HIVE_CONF/hive-site.xml"
addProperty "$HIVE_CONF/hive-site.xml" hive.metastore.warehouse.dir "$HIVE_WH"
addProperty "$HIVE_CONF/hive-site.xml" system:java.io.tmpdir /tmp/hive/java
addProperty "$HIVE_CONF/hive-site.xml" system:user.name ${user.name}
addProperty "$HIVE_CONF/hive-site.xml" hive.exec.scratchdir /tmp/hive
addProperty "$HIVE_CONF/hive-site.xml" hive.exec.local.scratchdir /tmp/hive
addProperty "$HIVE_CONF/hive-site.xml" hive.downloaded.resources.dir "/tmp/hive/${hive.session.id}_resources"
addProperty "$HIVE_CONF/hive-site.xml" hive.scratch.dir.permission 733

# guava errors
rm -rf "$HIVE_HOME"/lib/guav*.jar || true
rm -rf "$HIVE_HOME"/lib/*slf4j*.jar || true
cp "$HADOOP_HOME"/share/hadoop/hdfs/lib/guav*.jar "$HIVE_HOME/lib"

# init Derby
"$HIVE_HOME/bin/schematool" -dbType derby -initSchema
