# dockerfile to build image for Postgress AS

# start from rhel 7.2
FROM centos

# file author / maintainer
MAINTAINER "Gerben Kranenborg" "gkranenborg@gmail.com"

# update OS
# RUN yum -y update && \
RUN yum -y install sudo openssh-clients telnet unzip java-1.8.0-openjdk-devel && \
yum clean all

# enabling sudo group
# enabling sudo over ssh
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
sed -i 's/.*requiretty$/Defaults !requiretty/' /etc/sudoers

# create workdir
RUN mkdir -p /opt

WORKDIR /opt

# install Postgress AS 9.5
ADD ppasmeta-9.5.0.5-linux-x64.tar /tmp
ADD install-postgress /tmp
RUN chmod 755 /tmp/install-postgress
RUN /tmp/install-postgress
VOLUME /opt/edb/9.5AS/data
RUN useradd -m postgres ; echo postgres: | chpasswd ; usermod -a -G postgres postgres
RUN rm -rf /tmp/install-postgress /tmp/ppasmeta-9.5.0.5-linux-x64.tar
RUN source /opt/edb/9.5AS/pgplus_env.sh
RUN sed -i -e 's/#work_mem = 4MB/work_mem = 20MB/g' /opt/edb/9.5AS/data/postgresql.conf
RUN chmod 755 /opt/edb/connectors/jdbc/*jar
RUN POSTGRESJAR=`ls /opt/edb/connectors/jdbc/edb-*17.jar`
RUN sed -i -e "s/127\.0\.0\.1\/32/0\.0\.0\.0\/0/g" /opt/edb/9.5AS/data/pg_hba.conf
RUN echo "export PGDATA=/opt/edb/9.5AS/data" >>/root/.bashrc
ADD init.sh /opt/edb/9.5AS/bin
RUN chmod 755 /opt/edb/9.5AS/bin/init.sh

# Postgress ports
EXPOSE 5444
USER enterprisedb
ENTRYPOINT ["/opt/edb/9.5AS/bin/init.sh"]
CMD ["/bin/bash"]