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
    if [ "${RELEASE}" == "1" ] && [ "${LOCAL}" == "0" ] ; then
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
    local base_port=$3
    local new_port=$4
    local container_name=$5

    echo "###########################################################################################################"
    echo "### Creating new ${nodetype} with label ${container_name}!"
    docker-compose -f ${compose_file} run -d -p "${new_port}:${base_port}" --name ${container_name} ${nodetype}

}

erun() { echo "### $*" ; "$@" ; }

function dockerPrune() {
    erun docker container prune -f
    erun docker volume prune -f
    erun docker builder prune -f
}

function dockerCommandAll() {
    command=$1
    active_lst=$(docker ps | grep ${IMAGE_FAMILY} | sed 's/|/ /' | awk '{print $1}')
    if [[ -n ${active_lst} ]]; then
        printf "Running '${command}' for all Containers:\n\n%s\n\n" "$(docker container "${command}" ${active_lst})"
    fi
}

function dockerStop() {
    dockerCommandAll stop
}

function dockerStart() {
    dockerCommandAll start
}

function dockerRestart() {
    dockerCommandAll restart
}

function dockerDown() {
    dockerStop
    dockerPrune
}

function dockerPS() {
    local nodetype=$1
    local flags=$2
    docker ps | grep ${flags} "${nodetype}"
}

function dockerRemove() {
    local container_name=$1
    echo "###########################################################################################################"
    echo "### Destroying container $(docker rm -fv ${container_name})"
}

function findWorkers() {
    local nodetype=$1
    dockerPS ${nodetype} "-c"
}

function getContainerName() {
    local nodetype=$1
    local nodeid=$2
    echo ${COMPOSE_PROJECT_NAME}-${nodetype}-${nodeid}
}

function getNewPort() {
    local start_port=$1
    local nodeid=$2
    echo $(( start_port + nodeid - 1 ))
}

function dockerScaleDownAll() {
    local nodetype=$1
    local last_kill=${workers:-1}

    running="$( findWorkers $nodetype )"

    for i in $( eval echo {$running..$last_kill} | sort -r ); do
        dockerRemove "$(getContainerName ${nodetype} ${i})"
    done
}

function dockerScale() {

    local nodetype=$1
    local compose_file=$2
    local port=$3

    function dockerScaleAdd() {
        (( running ++ ))
        for i in $( eval echo {$running..$WORKERS} ); do
            dockerRun ${nodetype} ${compose_file} ${port} "$(getNewPort ${port} ${i} )" "$(getContainerName ${nodetype} ${i})"
        done
    }

    function dockerScaleSub() {
        last_kill=$(( WORKERS + 1 ))
        for i in $( eval echo {$running..$last_kill} | sort -r ); do
            dockerRemove "$(getContainerName ${nodetype} ${i})"
        done
    }

    running="$( findWorkers $nodetype )"
    if [[ running -eq 0 ]]; then
        dockerUp ${compose_file}
    fi

    if (( WORKERS > 6 )); then
        echo "#############################################################################################################"
        echo "### ERROR: The chosen worker count of ${WORKERS} exceeds the maximum of 6!"
    elif (( running > WORKERS )); then
        dockerScaleSub
    elif (( running < WORKERS )); then
        dockerScaleAdd
    fi

    echo "#############################################################################################################"
    echo "### Nodetype '${nodetype}' has $(findWorkers ${nodetype}) worker(s) [MAXIMUM 6]"
    echo "#############################################################################################################"

}

