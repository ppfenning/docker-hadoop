#!/bin/bash
# get GPG keys
curl -O https://dist.apache.org/repos/dist/release/hadoop/common/KEYS
gpg --import KEYS
# get Hadoop files
curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz # hadoop
curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc # keys
gpg --verify /tmp/hadoop.tar.gz.asc # verify
# open & move hadoop files
tar -xvf /tmp/hadoop.tar.gz -C /opt/ # open
rm /tmp/hadoop.tar.gz* # cleanup
# make links
ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop
# log folders
mkdir /opt/hadoop-$HADOOP_VERSION/logs
mkdir /hadoop-data
