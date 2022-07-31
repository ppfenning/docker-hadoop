ARG IMAGE_FAMILY=ppfenning/hadoop
ARG TAG=master
ARG PARENT=base
FROM ${IMAGE_FAMILY}-${PARENT}:${TAG}

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

ENV JAR_FILEPATH="/opt/hadoop/applications/WordCount.jar"
COPY WordCount.jar $JAR_FILEPATH
ENV CLASS_TO_RUN="WordCount"
ENV PARAMS="/input /output"

ADD wordcount.sh /scripts/
RUN chmod a+x /scripts/wordcount.sh

CMD ["/scripts/wordcount.sh"]
