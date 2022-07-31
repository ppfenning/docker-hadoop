#!/bin/bash

datafile=$1
override=$2

fname="$(echo "$datafile" | cut -d'.' -f1).csv"
# check if file on hdfs
docker exec namenode hdfs dfs -test -f "/data/${fname};"
# if no, load it
if [ $? -eq 1 ] || [ -n "${override}" ]; then
    docker cp "${datafile}" namenode:/"${datafile}"
    docker exec namenode source /functions/hdfs_tools.sh
    docker exec namenode addZippedCSVDataHadoop "${datafile}"
fi
