ifndef TAG
$(error The TAG variable is missing.)
endif

ifndef ENV
$(error The ENV variable is missing.)
endif

ifeq (,$(filter $(ENV),test dev))
COMPOSE_FILE_PATH := -f docker-compose.yml
endif

ACCOUNT_NAME = localhost:5000
COMPOSE_PROJECT_NAME = final-project
ENV_FOLD = .envfold
DOCKER_NETWORK = ${COMPOSE_PROJECT_NAME}_default
IMAGE_FAMILY = ${ACCOUNT_NAME}/${COMPOSE_PROJECT_NAME}

base-build:
	docker build -t ${COMPOSE_PROJECT_NAME}-base:${TAG} ./base
	docker tag "${COMPOSE_PROJECT_NAME}-base:${TAG}" "${IMAGE_FAMILY}-base:${TAG}"

nodes-build:
	docker build -t ${COMPOSE_PROJECT_NAME}-namenode:${TAG} ./namenode
	docker build -t ${COMPOSE_PROJECT_NAME}-datanode:${TAG} ./datanode

managers-build:
	docker build -t ${COMPOSE_PROJECT_NAME}-resourcemanager:${TAG} ./resourcemanager
	docker build -t ${COMPOSE_PROJECT_NAME}-nodemanager:${TAG} ./nodemanager
	docker build -t ${COMPOSE_PROJECT_NAME}-historyserver:${TAG} ./historyserver

create-tags:
	docker tag "${COMPOSE_PROJECT_NAME}-namenode:${TAG}" "${IMAGE_FAMILY}-namenode:${TAG}"
	docker tag "${COMPOSE_PROJECT_NAME}-datanode:${TAG}" "${IMAGE_FAMILY}-datanode:${TAG}"
	docker tag "${COMPOSE_PROJECT_NAME}-resourcemanager:${TAG}" "${IMAGE_FAMILY}-resourcemanager:${TAG}"
	docker tag "${COMPOSE_PROJECT_NAME}-nodemanager:${TAG}" "${IMAGE_FAMILY}-nodemanager:${TAG}"
	docker tag "${COMPOSE_PROJECT_NAME}-historyserver:${TAG}" "${IMAGE_FAMILY}-historyserver:${TAG}"

build: base-build nodes-build managers-build create-tags

up: build
	docker-compose up -d

pig:
	echo pig

hive:
	echo hive

spark:
	echo spark

extras: up ${EXTRAS}
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FOLD}/hadoop.env ${IMAGE_FAMILY}-base:${TAG} ls -lt /

wordcount: up
	docker build -t ${COMPOSE_PROJECT_NAME}-wordcount ./homeworks/submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FOLD}/hadoop.env ${IMAGE_FAMILY}-base:${TAG} hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FOLD}/hadoop.env ${IMAGE_FAMILY}-base:${TAG} hdfs dfs -copyFromLocal -f /opt/hadoop-3.2.3/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FOLD}/hadoop.env ${COMPOSE_PROJECT_NAME}-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FOLD}/hadoop.env ${IMAGE_FAMILY}-base:${TAG} hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FOLD}/hadoop.env ${IMAGE_FAMILY}-base:${TAG} hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FOLD}/hadoop.env ${IMAGE_FAMILY}-base:${TAG} hdfs dfs -rm -r /input

