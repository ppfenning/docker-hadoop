include .env
export

ifndef ENV
$(error The ENV variable is missing.)
endif

include config/${ENV}.env
export

$(shell chmod a+x scripts/*)

DOCKER_NETWORK = ${COMPOSE_PROJECT_NAME}_default

ifeq ($(RELEASE),1)
	IMAGE_FAMILY = ${ACCOUNT_NAME}/${COMPOSE_PROJECT_NAME}
else
	IMAGE_FAMILY = localhost:5000/${COMPOSE_PROJECT_NAME}
endif

ifeq ($(CACHED),0)
	BUILD_FLAG = --build
	CACHED_FLAG = --no-cache
endif

# runs everything important with make
start: down build up

# safe commands for whole network
build: build-base build-extras
up: up-vanilla up-extras
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
### BASE IMAGE
#######################################################################################################################

# base hadoop image
build-base:
	docker build ${CACHED_FLAG} -t ${IMAGE_FAMILY}-base:${TAG} ./base
ifeq ($(RELEASE),1)
	docker push ${IMAGE_FAMILY}-base:${TAG}
endif

#######################################################################################################################
### VANILLA NODES
#######################################################################################################################

# commands for namenode
up-name:
	# build volumes, network, and start namenode with extras (pig, hive)
	@docker-compose -f base/compose/docker-compose-name.yml up ${BUILD_FLAG} -d
stop-name:
	@docker-compose -f base/compose/docker-compose-name.yml stop
restart-name:
	@docker-compose -f base/compose/docker-compose-name.yml restart
down-name:
	@docker-compose --log-level=CRITICAL  -f base/compose/docker-compose-name.yml down

# commands for datanode
up-data:
	# add datanodes until worker limit of "${WORKERS}" is met
	@number=1 ; while [[ $$number -le ${WORKERS} ]] ; do \
		docker-compose --log-level ERROR -f base/compose/docker-compose-data.yml up ${BUILD_FLAG} -d --scale datanode=$$number; \
		((number = number + 1)) ; \
    done
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
build-pig:
	@docker build ${CACHED_FLAG} --build-arg IMAGE_FAMILY=${IMAGE_FAMILY} --build-arg TAG=${TAG} -t ${IMAGE_FAMILY}-pig:${TAG} ./extras/pig
ifeq ($(RELEASE),1)
	docker push ${IMAGE_FAMILY}-pig:${TAG}
endif
up-pig:
	@docker-compose -f extras/pig/docker-compose.yml up ${BUILD_FLAG} -d
down-pig:
	@docker-compose --log-level=CRITICAL -f extras/pig/docker-compose.yml down -v
stop-pig:
	@docker-compose -f extras/pig/docker-compose.yml stop
restart-pig:
	@docker-compose -f extras/pig/docker-compose.yml restart

# hive tools
build-hive:
	@docker build ${CACHED_FLAG} --build-arg IMAGE_FAMILY=${IMAGE_FAMILY} --build-arg TAG=${TAG} -t ${IMAGE_FAMILY}-hive:${TAG} ./extras/hive
ifeq ($(RELEASE),1)
	docker push ${IMAGE_FAMILY}-hive:${TAG}
endif
up-hive:
	@docker-compose -f extras/hive/docker-compose.yml up ${BUILD_FLAG} -d
down-hive:
	@docker-compose --log-level=CRITICAL -f extras/hive/docker-compose.yml down -v
stop-hive:
	@docker-compose -f extras/hive/docker-compose.yml stop
restart-hive:
	@docker-compose -f extras/hive/docker-compose.yml restart

# spark tools
build-spark:
	@docker-compose -f extras/spark/docker-compose.yml build ${CACHED_FLAG}
ifeq ($(RELEASE),1)
	docker push ${IMAGE_FAMILY}-spark:${TAG}
endif
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
build-extras: build-hive build-pig
down-extras: down-pig down-hive
stop-extras: stop-pig stop-hive
restart-extras: restart-pig restart-hive

#######################################################################################################################
### EXAMPLE PROBLEMS
#######################################################################################################################

insert-crimes:
	./scripts/get_crime_data.sh
pig-crimes: insert-crimes
	./scripts/run-example.sh pig
wordcount:
	./scripts/run-example.sh wordcount

