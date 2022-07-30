#!/bin/bash

datafile=$1

function addCSVDataHadoop() {

    fname="$(echo "$datafile" | cut -d'.' -f1).csv"
    # check if file on hdfs
    docker exec namenode hdfs dfs -test -f /data/$fname;
    # if no, load it
    if [ $? -eq 1 ]; then
        docker exec namenode hdfs dfs -mkdir -p /data/
        docker cp "$datafile" namenode:/"$datafile"
        docker exec namenode unzip "$datafile"
        docker exec namenode hadoop fs -put -f "$fname" /data
        docker exec namenode rm "$datafile" "$fname"
    fi

}
export -f addCSVDataHadoop
addCSVDataHadoop
