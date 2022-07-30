include config/.env.base
export

ifndef ENV
$(error The ENV variable is missing.)
endif

include config/.env.${ENV}
export

$(shell chmod a+x scripts/*)

DOCKER_NETWORK = ${COMPOSE_PROJECT_NAME}_default

ifeq ($(BUILD),release)
	IMAGE_FAMILY = ${ACCOUNT_NAME}/${COMPOSE_PROJECT_NAME}
else
	IMAGE_FAMILY = localhost:5000/${COMPOSE_PROJECT_NAME}
endif

ifeq ($(EXTRAS),1)
	PARENT = extras
else
	PARENT = base
endif

start: build up

build: down build-base build-extras build-nodes build-managers

build-base:
	docker build -t ${IMAGE_FAMILY}-base:${TAG} ./base
ifeq ($(BUILD),release)
	docker push ${IMAGE_FAMILY}-base:${TAG}
endif

build-extras:
	docker build --build-arg IMAGE_FAMILY=${IMAGE_FAMILY} --build-arg TAG=${TAG} -t ${IMAGE_FAMILY}-extras:${TAG} ./extras
ifeq ($(BUILD),release)
	docker push ${IMAGE_FAMILY}-extras:${TAG}
endif

build-namenode:
	./scripts/build-node.sh namenode

build-datanode:
	./scripts/build-node.sh datanode

build-resourcemanager:
	./scripts/build-node.sh resourcemanager

build-nodemanager:
	./scripts/build-node.sh nodemanager

build-historyserver:
	./scripts/build-node.sh historyserver

build-nodes: build-namenode build-datanode

build-managers: build-resourcemanager build-nodemanager build-historyserver

up-name:
	# build volumes, network, and start namenode with extras (pig, hive)
	@docker-compose -f compose/docker-compose-name.yml up -d
up-data:
	# add datanodes until worker limit of "${WORKERS}" is met
	@number=1 ; while [[ $$number -le ${WORKERS} ]] ; do \
		docker-compose --log-level ERROR -f compose/docker-compose-data.yml up -d --scale datanode=$$number; \
		((number = number + 1)) ; \
    done
up-managers:
	# start resourcemanager, nodemanager and history server
	@docker-compose -f compose/docker-compose-managers.yml up -d

up: up-name up-data up-managers

stop:
	# stop running containers, keeping networks and volumes intact
	@for value in name data managers; do \
        docker-compose -f compose/docker-compose-$$value.yml stop; \
    done
restart:
	# restart composed containers
	@for value in name data managers; do \
          docker-compose -f compose/docker-compose-$$value.yml restart; \
    done

down-containers:
	# tear down compose, delete all volumes and networks
	@for value in name data managers; do \
        docker-compose --log-level CRITICAL -f compose/docker-compose-$$value.yml down; \
    done

down-volumes:
	# remove volumes
	@docker volume prune -f

down: down-containers down-volumes


save:
	./scripts/image-saves.sh

insert-crimes:
	./scripts/get_crime_data.sh

pig-crimes: insert-crimes
	@docker cp examples/pig/run.pig namenode:/run.pig
	@docker exec namenode pig -f run.pig

wordcount:
	@docker build -t ${COMPOSE_PROJECT_NAME}-wordcount ./examples/wordcount | tee >/dev/null
	@docker exec namenode hdfs dfs -mkdir -p /input/
	@docker exec namenode hadoop fs -put -f /opt/hadoop-3.2.3/README.txt /input/
	@docker run --network ${DOCKER_NETWORK} --env-file config/hadoop.env ${COMPOSE_PROJECT_NAME}-wordcount
	@docker exec namenode hdfs dfs -cat /output/*
	@docker exec namenode hdfs dfs -rm -r /output /input
