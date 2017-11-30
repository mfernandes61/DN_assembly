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
# need fastqc, screen and wget
RUN apt-get update && apt-get -y install screen wget fastqc
RUN  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
#fix fastqc
RUN mkdir /etc/fastqc && mkdir /etc/fastqc/Configuration
ADD fastqc/* /etc/fastqc/Configuration/
# install Miniconda
RUN wget "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"  && bash Miniconda3-latest-Linux-x86_64.sh
RUN echo 'export PATH=/home/bsbXX/miniconda3/bin:$PATH' >> ~/.bashrc && source .bashrc 

RUN mkdir $DOCS && mkdir $DATA &&  mkdir $WORK && mkdir /coursehome && conda config --add channels r \
&& conda config --add channels conda-forge && conda config --add channels bioconda
#Install seqkit
RUN conda install -y seqkit
# install flash
#
# Install spades
RUN conda install spades 


#RUN  mkdir $DOCS && mkdir $DATA && mkdir $WORK
# ADD Docs\* $DOCS
# ADD Data\* $DATA
ADD Welcome.txt /etc/motd

#ADD entrypoint.sh /scripts/entrypoint.sh
#ADD launchsiab.sh /scripts/launchsiab.sh
#RUN chmod +x /usr/local/sbin/entrypoint.sh
RUN chmod +x /scripts/entrypoint.sh && chmod +x /scripts/launchsiab.sh

EXPOSE 22
EXPOSE 4200
VOLUME /coursehome
	
ENTRYPOINT ["/scripts/launchsiab.sh"]
CMD ["/bin/bash"]
