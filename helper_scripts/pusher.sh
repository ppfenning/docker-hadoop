make
current_branch=$(git rev-parse --abbrev-ref HEAD)
docker image push ppfenning/hadoop-base:"${current_branch}"
docker image push ppfenning/hadoop-namenode:"${current_branch}"
docker image push ppfenning/hadoop-datanode:"${current_branch}"
docker image push ppfenning/hadoop-nodemanager:"${current_branch}"
docker image push ppfenning/hadoop-resourcemanager:"${current_branch}"
docker image push ppfenning/hadoop-historyserver:"${current_branch}"
docker image push ppfenning/big-data-crime-stats:"${current_branch}"
