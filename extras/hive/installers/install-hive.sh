#!/bin/bash

# download hive
curl -fSL "$HIVE_URL" -o /tmp/hive-"$HIVE_VERSION".tar.gz
mkdir -p "$HIVE_BASE"
tar -xvf /tmp/hive-"$HIVE_VERSION".tar.gz -C "$HIVE_BASE"
rm /tmp/hive-"$HIVE_VERSION".tar.gz
