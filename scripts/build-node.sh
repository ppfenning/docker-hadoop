#!/bin/bash

nodename=$1

echo "================================================================================================================="
echo
echo "Building ${nodename}..."
echo
docker build \
    --build-arg IMAGE_FAMILY="${IMAGE_FAMILY}" \
    --build-arg TAG="${TAG}" \
    --build-arg PARENT="${PARENT}" \
    -t "${IMAGE_FAMILY}-${nodename}:${TAG}" \
    "./${nodename}"

if [ "${BUILD}" == "release" ]; then
    echo
    echo "Pushing ${nodename} to ${ACCOUNTNAME}..."
    echo
    docker image push "${IMAGE_FAMILY}-${nodename}:${TAG}"
fi

echo "================================================================================================================="
