#!/bin/bash

function mkdirHadoop() {
  local newdir=$1

  hadoop fs -test -d "${newdir}";

  if [ $? -eq 1 ]
  then
      hdfs dfs -mkdir -p "${newdir}"
  fi
  hdfs dfs -chmod a+w "${newdir}"
}

function addCSVDataHadoop() {

    local datafile=$1
    fname="$(basename "${datafile}" | cut -d'.' -f1).csv"

    # check if file on hdfs
    hdfs dfs -test -f "/data/${fname}";
    # if no, load it
    if [ $? -eq 1 ]; then
        mkdirHadoop /data/
        unzip "${datafile}" -d /data/
        hdfs dfs -put -f "/data/${fname}" /data/
    fi
    hadoop fs -cat "/data/${fname}" | head
}
