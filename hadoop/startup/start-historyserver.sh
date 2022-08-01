#!/bin/bash

mkdir -p /hadoop/yarn/timeline
yarn --config "${HADOOP_CONF_DIR}" historyserver
