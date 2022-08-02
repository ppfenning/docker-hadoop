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
start: down build up

# safe commands for whole network
down: down-vanilla down-extras down-volumes down-cache
stop: stop-extras stop-base
restart: restart-extras restart-base

# cleaning tools
down-volumes:
	# remove volumes
	@docker volume prune -f
down-cache:
	# prune cache
	@docker builder prune -f

# save build images to file
save:
	./scripts/image-saves.sh

#######################################################################################################################
### BUILD IMAGES
#######################################################################################################################

build: | hadoop.build hive.build pig.build
hadoop.build : hadoop
spark.build : spark
hive.build : hive
pig.build : pig

%.build:
	@$(STE) dockerBuild $^
%.up:
	@$(STE) dockerUp $^
%.run:
	@$(STE) dockerRun $^


#######################################################################################################################
### VANILLA NODES
#######################################################################################################################

# commands for namenode

up: | namenode.up managers.up
namenode.up: hadoop/compose/docker-compose-name.yml
managers.up: hadoop/compose/docker-compose-managers.yml

stop-name:
	@docker-compose -f base/compose/docker-compose-name.yml stop
restart-name:
	@docker-compose -f base/compose/docker-compose-name.yml restart
down-name:
	@docker-compose -f hadoop/compose/docker-compose-name.yml down


datanode.scaled:
	@$(STE) dockerScale datanode hadoop/compose/docker-compose-data.yml 9864
stop-data:
	@docker-compose -f base/compose/docker-compose-data.yml stop
restart-data:
	@docker-compose -f base/compose/docker-compose-data.yml restart
down-data:
	@docker-compose --log-level=CRITICAL  -f base/compose/docker-compose-data.yml down

# commands for managers
up-managers:
	# start resourcemanager, nodemanager and history server
	@docker-compose -f base/compose/docker-compose-managers.yml up ${BUILD_FLAG} -d
stop-managers:
	@docker-compose -f base/compose/docker-compose-managers.yml stop
restart-managers:
	@docker-compose -f base/compose/docker-compose-managers.yml restart
down-managers:
	@docker-compose --log-level=CRITICAL  -f base/compose/docker-compose-managers.yml down

# commands for vanilla tools
up-vanilla: up-name up-data up-managers
down-vanilla: down-managers down-data down-name
stop-vanilla: stop-managers stop-data stop-name
restart-vanilla: restart-managers restart-data restart-name

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

# grouped commands for extra tools
up-extras: up-hive up-pig
down-extras: down-pig down-hive
stop-extras: stop-pig stop-hive
restart-extras: restart-pig restart-hive

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
