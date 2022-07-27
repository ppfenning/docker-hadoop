include .env
export

ifeq (,$(filter $(ENV),test dev))
COMPOSE_FILE_PATH := -f docker-compose.yml
endif

ENV_FOLD = .envfold
DOCKER_NETWORK = ${COMPOSE_PROJECT_NAME}_default

ifeq ($(BUILD),release)
	IMAGE_FAMILY = ${ACCOUNT_NAME}/${COMPOSE_PROJECT_NAME}
else
	IMAGE_FAMILY = localhost:5000/${COMPOSE_PROJECT_NAME}
endif

build: base-build node-build manager-build

build-up: build up

base-build:
	docker build -t ${IMAGE_FAMILY}-base:${TAG} ./base
ifeq ($(BUILD),release)
	docker push ${IMAGE_FAMILY}-base:${TAG}
endif

node-build:
	docker build --build-arg IMAGE_NAME=${IMAGE_FAMILY}-base:${TAG} -t ${IMAGE_FAMILY}-namenode:${TAG} ./namenode
	docker build --build-arg IMAGE_NAME=${IMAGE_FAMILY}-base:${TAG} -t ${IMAGE_FAMILY}-datanode:${TAG} ./datanode
ifeq ($(BUILD),release)
	docker image push ${IMAGE_FAMILY}-namenode:${TAG} && \
	docker image push ${IMAGE_FAMILY}-datanode:${TAG}
endif

manager-build:
	docker build --build-arg IMAGE_NAME=${IMAGE_FAMILY}-base:${TAG} -t ${IMAGE_FAMILY}-resourcemanager:${TAG} ./resourcemanager
	docker build --build-arg IMAGE_NAME=${IMAGE_FAMILY}-base:${TAG} -t ${IMAGE_FAMILY}-nodemanager:${TAG} ./nodemanager
	docker build --build-arg IMAGE_NAME=${IMAGE_FAMILY}-base:${TAG} -t ${IMAGE_FAMILY}-historyserver:${TAG} ./historyserver
ifeq ($(BUILD),release)
	docker image push ${IMAGE_FAMILY}-nodemanager:${TAG} && \
	docker image push ${IMAGE_FAMILY}-resourcemanager:${TAG} && \
	docker image push ${IMAGE_FAMILY}-historyserver:${TAG}
endif

# build volumes, network, and start container
up:
	# initialize base network
	docker-compose up -d
	# add datanodes until worker limit is met
	# this is done in a b/c parallel scaling is broken in v2
	number=2 ; while [[ $$number -le ${WORKERS} ]] ; do \
		docker-compose up -d --scale datanode=$$number; \
		((number = number + 1)) ; \
    done
# stop running containers, keeping networks and volumes intact
stop:
	docker-compose stop
# restart composed containers
restart:
	docker-compose restart
# tear down compose, delete all volumes and networks
down:
	docker-compose down -v --remove-orphans

pig:
	@echo pig

hive:
	@echo hive

spark:
	@echo spark

wordcount:
	@docker build -t ${COMPOSE_PROJECT_NAME}-wordcount ./examples/wordcount | tee >/dev/null
	@docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FOLD}/hadoop.env ${IMAGE_FAMILY}-base:${TAG} hdfs dfs -mkdir -p /input/ | tee >/dev/null
	@docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FOLD}/hadoop.env ${IMAGE_FAMILY}-base:${TAG} hdfs dfs -copyFromLocal -f /opt/hadoop-3.2.3/README.txt /input/ | tee >/dev/null
	@docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FOLD}/hadoop.env ${COMPOSE_PROJECT_NAME}-wordcount | tee >/dev/null
	@docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FOLD}/hadoop.env ${IMAGE_FAMILY}-base:${TAG} hdfs dfs -cat /output/*
	@docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FOLD}/hadoop.env ${IMAGE_FAMILY}-base:${TAG} hdfs dfs -rm -r /output | tee >/dev/null
	@docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FOLD}/hadoop.env ${IMAGE_FAMILY}-base:${TAG} hdfs dfs -rm -r /input | tee >/dev/null

