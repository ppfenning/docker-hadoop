#!/bin/bash

hdfs dfs -mkdir -p /input/
hadoop fs -put -f "${HADOOP_HOME}/LICENSE.txt" /input/
hadoop jar ${JAR_FILEPATH} ${CLASS_TO_RUN} ${PARAMS}
hdfs dfs -cat /output/*
