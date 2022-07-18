DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)
KAGGLE_TOKEN=$(shell cat ~/.kaggle/kaggle.json)
build:
	docker build -t ppfenning/hadoop-base:$(current_branch) ./base
	docker build -t ppfenning/hadoop-namenode:$(current_branch) ./namenode
	docker build -t ppfenning/hadoop-datanode:$(current_branch) ./datanode
	docker build -t ppfenning/hadoop-resourcemanager:$(current_branch) ./resourcemanager
	docker build -t ppfenning/hadoop-nodemanager:$(current_branch) ./nodemanager
	docker build -t ppfenning/hadoop-historyserver:$(current_branch) ./historyserver
	docker build -t ppfenning/big-data-crime-stats:$(current_branch) ./crime-stats

wordcount:
	docker build -t hadoop-wordcount ./submit
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} ppfenning/hadoop-base:$(current_branch) hdfs dfs -mkdir -p /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} ppfenning/hadoop-base:$(current_branch) hdfs dfs -copyFromLocal -f /opt/hadoop-3.2.3/README.txt /input/
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} hadoop-wordcount
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} ppfenning/hadoop-base:$(current_branch) hdfs dfs -cat /output/*
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} ppfenning/hadoop-base:$(current_branch) hdfs dfs -rm -r /output
	docker run --network ${DOCKER_NETWORK} --env-file ${ENV_FILE} ppfenning/hadoop-base:$(current_branch) hdfs dfs -rm -r /input

