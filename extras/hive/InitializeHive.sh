#!/bin/bash

# source custom functions
source /functions/property_helper.sh
source /functions/hdfs_tools.sh

configure "${HIVE_SITE_DIR}/hive-site.xml" hive HIVE_CONF
mkdirHadoop /tmp/hive
mkdirHadoop /user/hive/warehouse
schematool -dbType derby -initSchema
