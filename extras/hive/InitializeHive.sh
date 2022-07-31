#!/bin/bash

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
mkdirHadoop /user/hive/warehouse
