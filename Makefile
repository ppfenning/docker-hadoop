DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_branch := $(shell git rev-parse --abbrev-ref HEAD)
build:
	docker build -t ppfenning/hadoop-base:$(current_branch) ./base
	docker build -t ppfenning/hadoop-namenode:$(current_branch) ./namenode
	docker build -t ppfenning/hadoop-datanode:$(current_branch) ./datanode
	docker build -t ppfenning/hadoop-resourcemanager:$(current_branch) ./resourcemanager
	docker build -t ppfenning/hadoop-nodemanager:$(current_branch) ./nodemanager
	docker build -t ppfenning/hadoop-historyserver:$(current_branch) ./historyserver