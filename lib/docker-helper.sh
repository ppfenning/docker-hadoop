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
    if [ "${RELEASE}" == "1" ]; then
        dockerPush ${image_name}
    fi
}

function dockerUp() {
    compose_file=$1
    docker-compose -f ${compose_file} up ${BUILD_FLAG} --no-recreate -d
}

function dockerRun() {

    local nodetype=$1
    local compose_file=$2
    local port=$3

    echo "Creating new ${nodetype}!"
    docker-compose -f ${compose_file} run -d -p ${port} ${nodetype}

}

function dockerRemove() {

    local compose_file=$1
    local container_name=$2
    echo "Destroying ${nodetype} with label ${container_name}!"
    docker rm -fv ${container_name}

}

function findWorkers() {
    local nodetype=$1
    docker ps | grep -c "${nodetype}"
}

function dockerScale() {

    local nodetype=$1
    local compose_file=$2
    local port=$3

    function dockerScaleUp() {
        (( running ++ ))
        for i in $( eval echo {$running..$WORKERS} ); do
            (( port++ ))
            dockerRun ${nodetype} ${compose_file} $port
        done
    }

    function dockerScaleDown() {
        for i in $( eval echo {$running..$WORKERS} ); do
            (( port++ ))
            dockerRun ${nodetype} ${compose_file} $port
        done
    }

    running="$( findWorkers $nodetype )"
    if [[ running -eq 0 ]]; then
        echo 1
        dockerUp ${compose_file}
    fi
    if (( running > WORKERS )); then
        dockerScaleDown
    elif (( running < WORKERS )); then
        dockerScaleUp
    fi

    docker ps | grep ${nodetype}

}
