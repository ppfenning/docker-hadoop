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

function addZippedCSVDataHadoop() {

    local datafile=$1
    fname="$(echo "${datafile}" | cut -d'.' -f1).csv"

    # check if file on hdfs
    mkdirHadoop /data/
    unzip "$datafile"
    hadoop fs -put -f "$fname" /data
    rm "$datafile" "$fname"

}
