#!/bin/bash

apt-get update && apt-get -y --no-install-recommends install unzip
cd /data || exit
unzip Chicago_Crimes.zip
rm Chicago_Crimes.zip
