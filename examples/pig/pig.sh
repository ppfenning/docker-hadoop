#!/bin/bash

# get tools
source /functions/hdfs_tools.sh
# move to hdfs
# NOTE: having issue running mapreduce, will run local but still move data to hdfs for future use
addCSVDataHadoop /data/Chicago_Crimes.csv
ls -l /data
## because we are running local, we must move pig output to hdfs manually
mkdirHadoop /output/pigout
## run pig command
pig -x local -f /scripts/run.pig
ls -R /pigout
hdfs dfs -put /pigout/ /output/pigout
