ARG IMAGE_NAME=ppfenning/hadoop-base:master
FROM ${IMAGE_NAME}

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

HEALTHCHECK CMD curl -f http://localhost:$DATA_PORT/ || exit 1

ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data
VOLUME /hadoop/dfs/data

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 9864

CMD ["/run.sh"]
