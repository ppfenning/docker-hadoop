#!/bin/bash

source ./lib/docker-helper.sh

example=$1
compose_file=$2

echo "================================================================================================================="
echo "Running example container ${example}..."
echo "================================================================================================================="
erun docker-compose -f ${compose_file} run ${example}
echo "================================================================================================================="
echo "Job complete!"
echo "================================================================================================================="
dockerPrune
echo "================================================================================================================="
