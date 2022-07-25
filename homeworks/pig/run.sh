#!/bin/bash

rm -r pigout/ || true
pig -x local -f /run.pig
find pigout/ -mindepth 2 -type f -exec cat {} + | tac | tee solutions.txt