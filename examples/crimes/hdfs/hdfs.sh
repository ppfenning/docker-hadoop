#!/bin/bash

# get tools
source /functions/hdfs_tools.sh
# get tools
addCSVDataHadoop /data/Chicago_Crimes.csv
mkdirHadoop /homework/
