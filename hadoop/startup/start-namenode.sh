#!/bin/bash

mkdir -p /hadoop/dfs/name

namedir=$(echo "${HDFS_CONF_dfs_namenode_name_dir}" | perl -pe 's#file://##')
if [ ! -d "${namedir}" ]; then
  echo "Namenode name directory not found: ${namedir}"
  exit 2
fi

if [ -z "${CLUSTER_NAME}" ]; then
  echo "Cluster name not specified"
  exit 2
fi

echo "remove lost+found from ${namedir}"
rm -rf "${namedir}/lost+found"

if [ "$(ls -A "${namedir}")" == "" ]; then
  echo "Formatting namenode name directory: ${namedir}"
  hdfs --config "${HADOOP_CONF_DIR}" namenode -format "${CLUSTER_NAME}"
fi

hdfs --config "${HADOOP_CONF_DIR}" namenode
