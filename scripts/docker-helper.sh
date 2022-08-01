#!/bin/bash

function buildArg() {
    local arg_file=$1
    awk '{ sub ("\\\\$", " "); printf " --build-arg %s", $0  } END { print ""  }' "${arg_file}"
}

VERSION_ARGS=$(buildArg ./config/versions.env)

function dockerPush() {
    local image_name=$1
    docker push ${image_name}
}

function dockerBuild() {
    local image_dir=$1
    local image_name="${IMAGE_FAMILY}-${image_dir}:${TAG}"
    docker build ${CACHED_FLAG} --build-arg IMAGE_FAMILY=${IMAGE_FAMILY} \
            --build-arg TAG=${TAG} \
            ${VERSION_ARGS} \
           -t ${image_name} \
           ./${image_dir}
    if [ -n "${RELEASE}" ]; then
        dockerPush ${image_name}
    fi
}

function dockerUp() {
    compose_file=$1
    docker-compose -f ${compose_file} up ${BUILD_FLAG} -d
}
