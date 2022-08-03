#######################################################################################################################
### ENV VARIABLES
#######################################################################################################################
# use branch for tagging unless given in ENV
TAG = $(shell git rev-parse --abbrev-ref HEAD)

# always include default env
include ./config/default.env
export

# if ENV param is present, also include additional env files
# this will overwrite defaults if any keys match
ifdef ENV
	include ./config/${ENV}.env
    export
else
	ENV = default
endif

#######################################################################################################################
### ADDITIONAL PARAMETERS
#######################################################################################################################

# overwrite ACCOUNT name if building locally
ifeq ($(LOCAL),1)
	ACCOUNT_NAME = localhost:5000
endif

# flags for building docker containers
ifeq ($(CACHED),0)
	BUILD_FLAG := --build
	CACHED_FLAG := --no-cache
endif

# name of network compose uses
DOCKER_NETWORK = ${COMPOSE_PROJECT_NAME}_default
# all images have the same tag prefix
# helps with deleting, fills in compose/Dockerfile args
IMAGE_FAMILY = ${ACCOUNT_NAME}/${COMPOSE_PROJECT_NAME}
# build network using hadoop or spark setup
# may fully parameterize compose and/or build single compose for build with make
# this would make docker-compose down much simpler
COMPOSE_PREFIX = ${BACKEND}/compose/docker-compose

#######################################################################################################################
### SOURCE FUNCTIONS
#######################################################################################################################

# make shell functions executable
$(shell chmod +x scripts/* lib/*)
# sources files to allow function use
STE = bash sourceThenExec.sh

#######################################################################################################################
### INITIALIZE network
#######################################################################################################################
# runs everything important with make
init: build down up

#######################################################################################################################
### IMAGE TOOLS
#######################################################################################################################
# save build images to file
save:
	./scripts/image-saves.sh

#######################################################################################################################
### BUILD IMAGES
#######################################################################################################################

# allows key usage
.PHONY: hadoop spark hive pig
# build images in passed floder
%.build:
	@$(STE) dockerBuild $^
# build all images using desired backend
build: | ${BACKEND}.build hive.build pig.build
# build hadoop
hadoop.build : hadoop
# build spark
spark.build : spark
# build hive
hive.build : hive
# build pig
pig.build : pig

#######################################################################################################################
### CONTAINER FUNCTIONS
#######################################################################################################################

# destroy network (stop, remove, prune)
down:
	@$(STE) dockerDown
# stops all containers in network
stop:
	@$(STE) dockerStop
# starts all containers which are inactive
start:
	@$(STE) dockerStart
# restart active containers
restart:
	@$(STE) dockerRestart
# clean stray data (volumes, cache, stopped containers)
clean:
	@$(STE) dockerPrune

#######################################################################################################################
### HDFS STARTUP
#######################################################################################################################

# start full network
up: | namenode.up datanode-scaled managers.up pig.up hive.up
# up from passed compose
%.up:
	@$(STE) dockerUp $^
# bring up namenode
namenode.up: ${COMPOSE_PREFIX}-name.yml
# scale datanode to WORKERS
datanode-scaled:
	@$(STE) dockerScale datanode ${COMPOSE_PREFIX}-data.yml 9864
# start resourcemanager, nodemanager and historyserver
managers.up: ${COMPOSE_PREFIX}-managers.yml

#######################################################################################################################
### OTHER APACHE TOOLS STARTUP
#######################################################################################################################

# start pignode
pig.up: pig/docker-compose.yml | namenode.up
# start hivenode
hive.up: hive/docker-compose.yml | namenode.up

#######################################################################################################################
### EXAMPLES
#######################################################################################################################

# retrieve and clean Chicago_Crimes dataset from kaggle
insert-crimes:
	./scripts/get_crime_data.sh
# generic examples function (namenode must be active)
%.example: | namenode.up
	@./scripts/run-example.sh $^
# PHONY keys for examples
.PHONY: wordcount pig-crime
# runs pig example
pig-crime.example: pig-crime examples/pig-crime/docker-compose.yml | insert-crimes
# runs classic hdfs wordcount
wordcount.example: wordcount examples/wordcount/docker-compose.yml

#######################################################################################################################
### TERMINALS
#######################################################################################################################

# open bash terminal on namenode
namenode-term: | namenode.up
	docker-compose exec namenode bash

# opens grunt terminal
%.pignode.term: | pig.up
	docker-compose exec pignode /startup/start-pig-$^.sh
# PHONY keys for pig terminals
.PHONY: local mapreduce
# open local grunt terminal
local.pignode.term: local
# use as default
pignode-term: local.pignode.term
# opens mapreduce terminal
mapreduce.pignode.term: mapreduce

# open beehive terminal with workerbee user
hivenode-term: | hive.up
	docker-compose exec -u workerbee hivenode /startup/start-beeline.sh
