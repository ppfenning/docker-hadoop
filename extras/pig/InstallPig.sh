#!/bin/bash

echo "Pig is not installed! Installing Pig..."
curl -fSL "$PIG_URL" -o "/tmp/pig-$PIG_VERSION.tar.gz"
mkdir -p /usr/lib/pig/
tar -xvf "/tmp/pig-$PIG_VERSION.tar.gz" -C /usr/lib/pig/
rm "/tmp/pig-$PIG_VERSION.tar.gz"
echo "Install Successful!"
