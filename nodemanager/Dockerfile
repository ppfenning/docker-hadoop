ARG IMAGE_NAME=ppfenning/hadoop-base:master
FROM ${IMAGE_NAME}

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8042

CMD ["/run.sh"]
