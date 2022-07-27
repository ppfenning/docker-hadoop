#!/bin/bash

CONTAINER=$1

RUNNING=$(docker inspect --format="{{ .State.Running }}" "$CONTAINER" 2> /dev/null)

if [ $? -ne 1 ]; then
  docker rm --force "$CONTAINER" | tee >/dev/null
fi
