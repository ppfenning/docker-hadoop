include .env
export

TAG = $(shell git rev-parse --abbrev-ref HEAD)
LOCAL = 1
BACKEND = hadoop
ifeq ($(LOCAL),1)
	ACCOUNT_NAME = localhost:5000
endif
DOCKER_NETWORK = ${COMPOSE_PROJECT_NAME}_default
IMAGE_FAMILY = ${ACCOUNT_NAME}/${COMPOSE_PROJECT_NAME}
COMPOSE_PREFIX = ${BACKEND}/compose/docker-compose

$(shell chmod +x scripts/* lib/*)

ifeq ($(CACHED),0)
	BUILD_FLAG := --build
	CACHED_FLAG := --no-cache
endif

STE = bash sourceThenExec.sh
# runs everything important with make
init: build down up

# save build images to file
save:
	./scripts/image-saves.sh

#######################################################################################################################
### SHARED FUNCTIONS
#######################################################################################################################


%.build:
	@$(STE) dockerBuild $^
%.up:
	@$(STE) dockerUp $^

#######################################################################################################################
### BUILD IMAGES
#######################################################################################################################

.PHONY: hadoop spark hive pig

build-all: build-hadoop build-spark
build: | build-${BACKEND}
build-hadoop: | hadoop.build hive.build pig.build
build-spark: | spark.build hive.build pig.build
hadoop.build : hadoop
spark.build : spark
hive.build : hive
pig.build : pig


#######################################################################################################################
### VANILLA NODES
#######################################################################################################################

# commands for namenode

up: | namenode.up datanode-scaled managers.up pig.up hive.up
down:
	@$(STE) dockerDown
stop:
	@$(STE) dockerStop
start:
	@$(STE) dockerStart
restart:
	@$(STE) dockerRestart
clean:
	@$(STE) dockerPrune

namenode.up: ${COMPOSE_PREFIX}-name.yml
datanode-scaled:
	@$(STE) dockerScale datanode ${COMPOSE_PREFIX}-data.yml 9864
managers.up: ${COMPOSE_PREFIX}-managers.yml

#######################################################################################################################
### ADDITIONAL TOOLS
#######################################################################################################################

pig.up: pig/docker-compose.yml | namenode.up
hive.up: hive/docker-compose.yml | namenode.up

#######################################################################################################################
### EXAMPLES
#######################################################################################################################

insert-crimes:
	./scripts/get_crime_data.sh

.PHONY: wordcount pig-crime
pig-crime.example: pig-crime examples/pig-crime/docker-compose.yml | insert-crimes
wordcount.example: wordcount examples/wordcount/docker-compose.yml

%.example:
	@./scripts/run-example.sh $^

hdfs:
	docker-compose exec namenode $@ ${cmd}

namenode.term: | namenode.up
	docker-compose exec namenode bash
pignode.term: | pig.up
	docker-compose exec pignode /startup/start-pig-local.sh
hivenode.term: | hive.up
	docker-compose exec -u workerbee hivenode /startup/start-beeline.sh
