#!/bin/bash

# download tools
apt-get update && apt-get install -y wget procps
# get postgres
wget "${POSTGRES_URL}" -O "${HIVE_HOME}/lib/postgresql-jdbc.jar"
# clean up wget
apt-get --purge remove -y wget && apt-get clean && rm -rf /var/lib/apt/lists/*
