#!/bin/bash

datafile=$1

function addCSVDataHadoop() {

  docker exec namenode hdfs dfs -ls /data/$fname;
  docker exec namenode hdfs dfs -mkdir -p /data/
  fname="$(echo "$datafile" | cut -d'.' -f1).csv"
  docker cp "$datafile" namenode:/"$datafile"
  docker exec namenode unzip "$datafile"
  docker exec namenode hadoop fs -put -f "$fname" /data
  docker exec namenode rm "$datafile" "$fname"

}

addCSVDataHadoop
