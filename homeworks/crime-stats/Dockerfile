FROM hadoop-namenode

MAINTAINER Patrick Pfenning <pfenningp@wit.edu>

# Clean data
ADD Chicago_Crimes.zip /data/Chicago_Crimes.zip
ADD place_data.sh /place_data.sh
ENV CRIME_DATA=/data/Chicago_Crimes.csv

# make executable
RUN chmod a+x /place_data.sh
# run
RUN ["/place_data.sh"]
