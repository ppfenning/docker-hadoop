#!/bin/bash

# guava
echo "showing bad guava..."
ls $HIVE_HOME/lib/guava*
echo "removing bad guava..."
rm $HIVE_HOME/lib/guav*
echo "showing good guava..."
ls $HADOOP_HOME/share/hadoop/hdfs/lib/guav*
echo "copying good guava..."
cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava* $HIVE_HOME/lib/
echo "showing final local"
ls $HIVE_HOME/lib/guav*

# sl4j
echo "showing bad SL4J..."
ls $HIVE_HOME/lib/log4j-slf4*
echo "removing bad SL4J..."
rm $HIVE_HOME/lib/log4j-slf4*
