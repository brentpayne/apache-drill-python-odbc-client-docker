FROM python
MAINTAINER brentpayne

RUN apt-get update
RUN apt-get install -y screen emacs

WORKDIR /root
RUN apt-get remove libodbc1 unixodbc unixodbc-dev 
RUN apt-get install -y wget build-essential && \
  wget http://package.mapr.com/tools/MapR-ODBC/MapR_Drill/MapRDrill_odbc_v1.2.0.1000/MapRDrillODBC-1.2.0.x86_64.rpm && \
  apt-get install -y rpm && rpm -i --nodeps MapRDrillODBC-1.2.0.x86_64.rpm
RUN wget ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.1.tar.gz && \
  tar xf unixODBC-2.3.1.tar.gz && cd unixODBC-2.3.1 && \
  ./configure --disable-gui --disable-drivers --enable-iconv --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE && \
  make && make install
WORKDIR /root


ADD odbc.ini /root/.odbc.ini
ADD odbcinst.ini /root/.odbcinst.ini
ADD mapr.drillodbc.ini /root/.mapr.drillodbc.ini
ADD bashrc /root/.bashrc

ENV ODBCINI /root/.odbc.ini
ENV ODBCINSTINI /root/.odbcinst.ini
ENV ODBCSYSINI /root/.odbcinst.ini 
ENV MAPRDRILLINI /root/.mapr.drillodbc.ini 
ENV LD_LIBRARY_PATH /usr/local/lib:/opt/mapr/drillodbc/lib/64:/lib64:/usr/lib

#install pyodbc
RUN pip install pyodbc

CMD bash

