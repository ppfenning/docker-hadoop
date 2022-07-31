include config/.env.base
export

ifndef ENV
$(error The ENV variable is missing.)
endif

include config/.env.${ENV}
export

$(shell chmod a+x scripts/*)

DOCKER_NETWORK = ${COMPOSE_PROJECT_NAME}_default

ifeq ($(RELEASE),1)
	IMAGE_FAMILY = ${ACCOUNT_NAME}/${COMPOSE_PROJECT_NAME}
else
	IMAGE_FAMILY = localhost:5000/${COMPOSE_PROJECT_NAME}
endif

ifeq ($(EXTRAS),1)
	PARENT = extras
else
	PARENT = base
endif

COMPOSE_FILE_BASE := compose-${PARENT}/docker-compose

ifeq ($(CACHED),0)
	BUILD_FLAG = --build
	CACHED_FLAG = --no-cache
endif



start: down build up

build: build-base build-extras

build-base:
	docker build ${CACHED_FLAG} -t ${IMAGE_FAMILY}-base:${TAG} ./base
ifeq ($(RELEASE),1)
	docker push ${IMAGE_FAMILY}-base:${TAG}
endif

build-extras:
	docker build ${CACHED_FLAG} --build-arg IMAGE_FAMILY=${IMAGE_FAMILY} --build-arg TAG=${TAG} -t ${IMAGE_FAMILY}-extras:${TAG} ./extras
ifeq ($(RELEASE),1)
	docker push ${IMAGE_FAMILY}-extras:${TAG}
endif

up-name:
	# build volumes, network, and start namenode with extras (pig, hive)
	@docker-compose -f ${COMPOSE_FILE_BASE}-name.yml up ${BUILD_FLAG} -d
up-data:
	# add datanodes until worker limit of "${WORKERS}" is met
	@number=1 ; while [[ $$number -le ${WORKERS} ]] ; do \
		docker-compose --log-level ERROR -f ${COMPOSE_FILE_BASE}-data.yml up ${BUILD_FLAG} -d --scale datanode=$$number; \
		((number = number + 1)) ; \
    done
up-managers:
	# start resourcemanager, nodemanager and history server
	@docker-compose -f ${COMPOSE_FILE_BASE}-managers.yml up ${BUILD_FLAG} -d

up: up-name up-data up-managers

stop:
	# stop running containers, keeping networks and volumes intact
	@for value in name data managers; do \
        docker-compose -f ${COMPOSE_FILE_BASE}-$$value.yml stop; \
    done
restart:
	# restart composed containers
	@for value in name data managers; do \
          docker-compose -f ${COMPOSE_FILE_BASE}-$$value.yml restart; \
    done

down-containers:
	# tear down compose, delete all volumes and networks, prune cache
	@for value in name data managers; do \
		docker-compose --log-level CRITICAL -f ${COMPOSE_FILE_BASE}-$$value.yml down; \
	done

down-volumes:
	# remove volumes
	@docker volume prune -f

down-cache:
	# prune cache
	@docker builder prune -f

down: down-containers down-volumes down-cache

save:
	./scripts/image-saves.sh

insert-crimes:
	./scripts/get_crime_data.sh

pig-crimes: insert-crimes
	@docker cp examples/pig/run.pig namenode:/scripts/run.pig
	@docker exec namenode pig -f /scripts/run.pig

wordcount:
	./scripts/run-example.sh wordcount

