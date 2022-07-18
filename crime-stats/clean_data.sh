#!/bin/bash

apt-get update && apt-get -y --no-install-recommends install unzip
cd /data || exit
unzip Chicago_Crimes.zip
awk '!($19 == "")' Chicago_Crimes.csv > Cleansed_Crimes.csv
head Cleansed_Crimes.csv