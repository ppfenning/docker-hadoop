#!/bin/bash

mkdir -p /hadoop/dfs/data

datadir=$(echo "${HDFS_CONF_dfs_datanode_data_dir}" | perl -pe 's#file://##')
if [ ! -d "${datadir}" ]; then
  echo "Datanode data directory not found: ${datadir}"
  exit 2
fi

hdfs --config "${HADOOP_CONF_DIR}" datanode
