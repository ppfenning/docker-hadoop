ARG IMAGE_FAMILY=ppfenning/hadoop
ARG TAG=master
ARG PARENT=base
FROM ${IMAGE_FAMILY}-${PARENT}:${TAG}

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

HEALTHCHECK CMD curl -f http://localhost:8088/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8088

CMD ["/run.sh"]
