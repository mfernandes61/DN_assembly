FROM foodresearch/bppc

MAINTAINER Mark Fernandes <mark.fernandes@ifr.ac.uk>
ENV   SIAB_USER=ngsintro \
  SIAB_GROUP=guest \
  SIAB_PASSWORD=ngsintro \
  SIAB_HOME=/home/$SIAB_USER 

ENV DOCS=$SIAB_HOME/docs DATA=$SIAB_HOME/data WORK=$SIAB_HOME/work 

USER root
ADD copy_course.sh /scripts/copy_course.sh
RUN chmod +x /scripts/copy_course.sh 
# need fastqc, samtools bwa bowtie picard-tools GATK jre wget git
RUN apt-get update && apt-get -y install bowtie bwa curl default-jre fastqc git gzip monit \
    picard-tools poppler-utils samtools sudo wget
RUN  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
#fix fastqc
RUN mkdir /etc/fastqc && mkdir /etc/fastqc/Configuration
ADD fastqc/* /etc/fastqc/Configuration/

RUN mkdir $DOCS && mkdir $DATA &&  mkdir $WORK && mkdir /coursehome
#RUN  mkdir $DOCS && mkdir $DATA && mkdir $WORK

ADD Docs\* $DOCS
ADD Data\* $DATA
ADD GenomeAnalysisTK.jar $SIAB_HOME
ADD Welcome.txt /etc/motd

ADD entrypoint.sh /scripts/entrypoint.sh
ADD launchsiab.sh /scripts/launchsiab.sh
#RUN chmod +x /usr/local/sbin/entrypoint.sh
RUN chmod +x /scripts/entrypoint.sh && chmod +x /scripts/launchsiab.sh

EXPOSE 22
EXPOSE 4200
VOLUME /coursehome
	
ENTRYPOINT ["/scripts/launchsiab.sh"]
CMD ["/bin/bash"]
