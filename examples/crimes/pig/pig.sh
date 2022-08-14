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
# run each problem
for i in {1..10}
do
    # pig output dir
    pig_outdir="/pig-out/Q${i}"
    # .pig file
    pig_file="/pig/Q${i}.pig"
    # condensed solution
    sol_out="/homework/pig/Q${i}.csv"
    # check if solution exists
    hadoop fs -test -e "${sol_out}";
    if [ $? -eq 1 ] && [ -f "${pig_file}" ]
    then
      echo "========================================================"
      echo "Solving Q${i}..."
      echo "========================================================"
      # run problems
      pig -x local -f "${pig_file}"
      # remove schema config
      hadoop fs -rm "${pig_outdir}/.pig_schema"
      # compile data to csv
      hadoop fs -getmerge "${pig_outdir}" "./Q${i}.csv"
      # put csv on hdfs
      hdfs dfs -put -f "./Q${i}.csv" "${sol_out}"
      echo "========================================================"
      echo "Q${i} solution"
      echo "========================================================"
      # show solution csv
      hdfs dfs -cat "${sol_out}"
      echo "========================================================"
      echo "Removing data from ${pig_outdir}"
      echo "========================================================"
      # remove pig output
      hadoop fs -rm -r "${pig_outdir}"
    fi
done

echo "========================================================"
echo "Listing all solutions..."
echo "========================================================"
hdfs dfs -ls /homework/pig/
