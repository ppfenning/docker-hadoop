#!/bin/bash

curl -fSL $PIG_URL -o /tmp/pig-${PIG_VERSION}.tar.gz
mkdir /usr/lib/pig/
tar -xvf /tmp/pig-${PIG_VERSION}.tar.gz -C /usr/lib/pig/
rm /tmp/pig-${PIG_VERSION}.tar.gz
