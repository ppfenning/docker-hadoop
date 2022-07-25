ifndef TAG
$(error The TAG variable is missing.)
endif

ifndef ENV
$(error The ENV variable is missing.)
endif

ifeq (,$(filter $(ENV),test dev))
COMPOSE_FILE_PATH := -f docker-compose.yml
endif

DOCKER_NETWORK = final-project_default
ENV_FILE = hadoop.env

base-create:
	docker build -t "pfenning/final-project-base:${TAG}" ./base
	docker tag "pfenning/final-project-base:${TAG}" "localhost:5000/final-project-base:${TAG}"

install-pig:
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} "localhost:5000/final-project-base:${TAG}" hdfs dfs -mkdir -p /input/

build: base-create
	docker-compose build --no-cache

up:
	docker-compose up -d

down:
	docker-compose down
