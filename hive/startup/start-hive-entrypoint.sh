#!/bin/bash

/scripts/entrypoint.sh

# source custom functions
source /functions/property_helper.sh
source /functions/hdfs_tools.sh

# get init properties
sed 's/&#8;/ /' "$HIVE_HOME/conf/hive-default.xml.template" > "${HIVE_HOME}/conf/hive-site.xml"
# configure hive-site.xml
configure "${HIVE_HOME}/conf/hive-site.xml" hive HIVE_SITE_CONF

# make hdfs directories
mkdirHadoop /tmp/hive
mkdirHadoop /user/hive/warehouse

export CLASSPATH=$CLASSPATH:$HADOOP_HOME/lib/*:.$HIVE_HOME/lib/*:.
export CLASSPATH=$CLASSPATH:$HIVE_HOME/lib/*:.

# init-derby
schematool -dbType derby -initSchema | tee .hive_init

exec "$@"
