include .env
export

ENV := dev
TAG := $(shell git rev-parse --abbrev-ref HEAD)
COMPOSE_PROJECT_NAME := docker
ACCOUNT_NAME := ppfenning
DOCKER_NETWORK := ${COMPOSE_PROJECT_NAME}_default
WORKERS := 2
CACHES := 1
RELEASE := 0

ifneq ($(RELEASE),1)
	ACCOUNT_NAME := localhost:5000
endif
IMAGE_FAMILY := ${ACCOUNT_NAME}/${COMPOSE_PROJECT_NAME}

$(shell chmod +x scripts/* lib/*)

ifeq ($(CACHED),0)
	BUILD_FLAG := --build
	CACHED_FLAG := --no-cache
endif

STE = bash sourceThenExec.sh
# runs everything important with make
start: build down up

clean:
	@docker volume prune -f
	@docker builder prune -f

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
%.down:
	@$(STE) dockerDown $^
%.run:
	@$(STE) dockerRun $^
%.remove:
	@$(STE) dockerRemove $^
%.ps:
	@docker-compose -f $^ ps

#######################################################################################################################
### BUILD IMAGES
#######################################################################################################################

build: | hadoop.build hive.build pig.build
hadoop.build : hadoop
spark.build : spark
hive.build : hive
pig.build : pig


#######################################################################################################################
### VANILLA NODES
#######################################################################################################################

# commands for namenode

up: | namenode.up datanode-scaled managers.up
down: | managers.down datanode-down namenode.down clean

namenode.up: hadoop/compose/docker-compose-name.yml
namenode.down: hadoop/compose/docker-compose-name.yml
namenode.ps: hadoop/compose/docker-compose-name.yml

datanode-scaled:
	@$(STE) dockerScale datanode hadoop/compose/docker-compose-data.yml 9864
datanode-down:
	#@$(STE) dockerScaleDown datanode 0

managers.up: hadoop/compose/docker-compose-managers.yml
managers.down: hadoop/compose/docker-compose-managers.yml
managers.ps: hadoop/compose/docker-compose-managers.yml

hadoop-ps:
	@docker-compose -f hadoop/compose/docker-compose-name.yml ps
	@docker ps -q

#######################################################################################################################
### ADDITIONAL TOOLS
#######################################################################################################################

# pig tools
up-pig:
	@docker-compose -f extras/pig/docker-compose.yml up ${BUILD_FLAG} -d
down-pig:
	@docker-compose --log-level=CRITICAL -f extras/pig/docker-compose.yml down -v
stop-pig:
	@docker-compose -f extras/pig/docker-compose.yml stop
restart-pig:
	@docker-compose -f extras/pig/docker-compose.yml restart

up-hive:
	@docker-compose -f extras/hive/docker-compose.yml up ${BUILD_FLAG} -d
down-hive:
	@docker-compose --log-level=CRITICAL -f extras/hive/docker-compose.yml down -v
stop-hive:
	@docker-compose -f extras/hive/docker-compose.yml stop
restart-hive:
	@docker-compose -f extras/hive/docker-compose.yml restart

up-spark:
	@docker-compose -f extras/spark/docker-compose.yml up ${BUILD_FLAG} -d
down-spark:
	@docker-compose --log-level=CRITICAL -f extras/spark/docker-compose.yml down -v
stop-spark:
	@docker-compose -f extras/spark/docker-compose.yml stop
restart-spark:
	@docker-compose -f extras/spark/docker-compose.yml stop

#######################################################################################################################
### EXAMPLES
#######################################################################################################################

insert-crimes:
	./scripts/get_crime_data.sh

pig.example: pig | insert-crimes
wordcount.example: wordcount
wordcount:

%.example:
	@./scripts/run-example.sh $^
