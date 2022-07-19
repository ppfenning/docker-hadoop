FROM ppfenning/hadoop-namenode:master

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

# Clean data
ADD Chicago_Crimes.zip /data/Chicago_Crimes.zip
ADD place_data.sh /place_data.sh
ENV CRIME_DATA=/data/Chicago_Crimes.csv

# make executable
RUN chmod a+x /place_data.sh
# run
RUN ["/place_data.sh"]

# install Pig
ENV PIG_VERSION 0.17.0
ENV PIG_URL https://downloads.apache.org/pig/pig-$PIG_VERSION/pig-$PIG_VERSION.tar.gz

# get scripts in folder
ADD InstallPig.sh /InstallPig.sh
# make executable
RUN chmod a+x /InstallPig.sh
# run
RUN ["/InstallPig.sh"]

ENV PIG_HOME=/usr/lib/pig/pig-$PIG_VERSION
ENV PIG_CONF_DIR=$PIG_HOME/conf
ENV PIG_CLASSPATH=$PIG_CONF_DIR
ENV PATH=$PIG_HOME/bin:$PATH

RUN pig -version
