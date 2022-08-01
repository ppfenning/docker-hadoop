#!/bin/bash

# source custom functions
source /functions/property_helper.sh
source /functions/hdfs_tools.sh

# get init properties
sed 's/&#8;/ /' "$HIVE_HOME/conf/hive-default.xml.template" > "${HIVE_HOME}/conf/hive-site.xml"
# canfigure hive-site.xml
configure "${HIVE_SITE_DIR}/hive-site.xml" hive HIVE_CONF

# make hdfs directories
mkdirHadoop /tmp/hive
mkdirHadoop /user/hive/warehouse

# init derby
hiveserver2 --hiveconf hive.server2.enable.doAs=false
