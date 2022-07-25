FROM big-data-crime-stats

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

ADD run.pig /run.pig
ADD run.sh /run.sh

RUN chmod a+x /run.sh

ENTRYPOINT ["/run.sh"]

