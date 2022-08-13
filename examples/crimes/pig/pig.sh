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
# remove outputs
hadoop fs -rm -r /pig-out/
# run problems
pig -x local -f /pig/run.pig

touch pig.txt

for i in {1..10}
do
    qdir="/pig-out/Q${i}"
    hadoop fs -test -d "${qdir}";
    if [ $? -eq 0 ]
    then
      hadoop fs -rm "${qdir}/.pig_schema"
      hadoop fs -getmerge "${qdir}" "./Q${i}.csv"
      {
        echo "====================================================="
        echo "Q${i}"
        echo "====================================================="
        cat "./Q${i}.csv"
        echo
      } >> pig.txt
    fi
done

hdfs dfs -put -f pig.txt /homework/
echo
hdfs dfs -cat /homework/pig.txt
