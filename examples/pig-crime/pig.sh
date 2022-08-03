#!/bin/bash

# get tools
source /functions/hdfs_tools.sh

hdfs dfs -test -d /pig-in/crimes;
if [ $? -eq 1 ]; then
    echo "Loading crime data to Hadoop as PigStorage..."
    pig -x local -f /pig/pre_map.pig || exit 1
    echo "Success!"
else
    echo "Crime data exists in hdfs as PigStorage!"
fi
# show stored data
hdfs dfs -ls /pig-in/crimes
# run problems
pig -x local -f /pig/run.pig
