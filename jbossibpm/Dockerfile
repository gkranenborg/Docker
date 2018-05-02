# dockerfile to build image for JBoss EAP 6.4

# start from CentOS
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

# add a user for the application, with sudo permissions
RUN useradd -m jboss ; echo jboss: | chpasswd ; usermod -a -G wheel jboss

# create workdir
RUN mkdir -p /opt

WORKDIR /opt

# install JBoss EAP 6.4.0
ADD jboss-eap-6.4.zip /tmp/jboss-eap-6.4.zip
RUN unzip /tmp/jboss-eap-6.4.zip
RUN rm -rf /tmp/jboss-eap-6.4.zip

# set environment
ENV JBOSS_HOME /opt/jboss-eap-6.4

# change executable permissions
RUN chmod 755 $JBOSS_HOME/bin/*

# Apply specific setting changes to JBoss domain setup
RUN sed -i -e '/<servers>/,/<\/servers>/{//!d}' $JBOSS_HOME/domain/configuration/host.xml
RUN sed -i -s 's/security-realm=\"ApplicationRealm\"//g' $JBOSS_HOME/domain/configuration/domain.xml
RUN sed -i -e 's/230\.0\.0\.4/230\.0\.0\.1/g' $JBOSS_HOME/domain/configuration/domain.xml
RUN sed -i -e 's/231\.7\.7\.7/231\.7\.7\.1/g' $JBOSS_HOME/domain/configuration/domain.xml

# create JBoss console user
RUN $JBOSS_HOME/bin/add-user.sh admin Fujitsu.1 --silent
# configure JBoss
RUN echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> $JBOSS_HOME/bin/domain.conf

# set permission folder
RUN chown -R jboss:jboss /opt/jboss-eap-6.4

# JBoss ports
EXPOSE 8080 9990 9999 5444

# Apply JBoss patches
ADD jboss-eap-6/jboss-eap-6.4.1.CP.zip /tmp/jboss-eap-6.4.1.CP.zip
ADD jboss-eap-6/jboss-eap-6.4.2.CP.zip /tmp/jboss-eap-6.4.2.CP.zip
ADD jboss-eap-6/jboss-eap-6.4.3.CP.zip /tmp/jboss-eap-6.4.3.CP.zip
ADD jboss-eap-6/jboss-eap-6.4.4.CP.zip /tmp/jboss-eap-6.4.4.CP.zip
ADD jboss-eap-6/jboss-eap-6.4.5.CP.zip /tmp/jboss-eap-6.4.5.CP.zip
ADD jboss-eap-6/jboss-eap-6.4.6.CP.zip /tmp/jboss-eap-6.4.6.CP.zip
ADD jboss-eap-6/jboss-eap-6.4.7.CP.zip /tmp/jboss-eap-6.4.7.CP.zip
ADD jboss-eap-6/jboss-eap-6.4.8.CP.zip /tmp/jboss-eap-6.4.8.CP.zip
ADD jboss-eap-6/jboss-eap-6.4.9.CP.zip /tmp/jboss-eap-6.4.9.CP.zip
RUN $JBOSS_HOME/bin/jboss-cli.sh --command="patch apply /tmp/jboss-eap-6.4.1.CP.zip"
RUN $JBOSS_HOME/bin/jboss-cli.sh --command="patch apply /tmp/jboss-eap-6.4.2.CP.zip"
RUN $JBOSS_HOME/bin/jboss-cli.sh --command="patch apply /tmp/jboss-eap-6.4.3.CP.zip"
RUN $JBOSS_HOME/bin/jboss-cli.sh --command="patch apply /tmp/jboss-eap-6.4.4.CP.zip"
RUN $JBOSS_HOME/bin/jboss-cli.sh --command="patch apply /tmp/jboss-eap-6.4.5.CP.zip"
RUN $JBOSS_HOME/bin/jboss-cli.sh --command="patch apply /tmp/jboss-eap-6.4.6.CP.zip"
RUN $JBOSS_HOME/bin/jboss-cli.sh --command="patch apply /tmp/jboss-eap-6.4.7.CP.zip"
RUN $JBOSS_HOME/bin/jboss-cli.sh --command="patch apply /tmp/jboss-eap-6.4.8.CP.zip"
RUN $JBOSS_HOME/bin/jboss-cli.sh --command="patch apply /tmp/jboss-eap-6.4.9.CP.zip"
RUN rm -rf /tmp/jboss*.zip
ADD BZ-1358913.zip /tmp/BZ-1358913.zip
RUN $JBOSS_HOME/bin/jboss-cli.sh --command="patch apply /tmp/BZ-1358913.zip"
RUN rm -rf /tmp/BZ-1358913.zip
RUN mkdir /opt/jboss-eap-6.4/domain/log
RUN chmod 755 /opt/jboss-eap-6.4/domain/log

# install Postgress AS 9.5
ADD ppasmeta-9.5.0.5-linux-x64.tar /tmp
ADD install-postgres /tmp
RUN chmod 755 /tmp/install-postgres
RUN /tmp/install-postgres
VOLUME /opt/edb/9.5AS/data
RUN useradd -m postgres ; echo postgres: | chpasswd ; usermod -a -G postgres postgres
RUN rm -rf /tmp/install-postgres /tmp/ppasmeta-9.5.0.5-linux-x64.tar
RUN source /opt/edb/9.5AS/pgplus_env.sh
RUN sed -i -e 's/#work_mem = 4MB/work_mem = 20MB/g' /opt/edb/9.5AS/data/postgresql.conf
RUN chmod 755 /opt/edb/connectors/jdbc/*jar
RUN POSTGRESJAR="/opt/edb/connectors/jdbc/edb-jdbc17.jar"
RUN sed -i -e "s/127\.0\.0\.1\/32/0\.0\.0\.0\/0/g" /opt/edb/9.5AS/data/pg_hba.conf
RUN echo "export PGDATA=/opt/edb/9.5AS/data" >>/root/.bashrc
ADD init.sh /init.sh
RUN chmod 755 /init.sh

ADD clijdbc /tmp/clijdbc
RUN /opt/jboss-eap-6.4/bin/jboss-cli.sh --file=/tmp/clijdbc
RUN rm -rf /tmp/clijdbc
ADD I-BPM11.4.1-EnterpriseEdition-CD_IMAGE_IF1141011.zip /tmp/I-BPM11.4.1-EnterpriseEdition-CD_IMAGE_IF1141011.zip
RUN unzip -o /tmp/I-BPM11.4.1-EnterpriseEdition-CD_IMAGE_IF1141011.zip 'engine/*'
RUN rm -rf /tmp/I-BPM11.4.1-EnterpriseEdition-CD_IMAGE_IF1141011.zip

RUN sed -i -e 's/database_selected\=/database_selected\=EDBPostgres/g' /opt/engine/server/setup.config
RUN sed -i -e 's/jdbc_module_name\=/jdbc_module_name\=com.postgres.jdbc/g' /opt/engine/server/setup.config
RUN sed -i -e "s/db_ibpm_password\=/db_ibpm_password\=Fujitsu1/g" /opt/engine/server/setup.config
RUN sed -i -e "s/db_port\=/db_port\=5444/g" /opt/engine/server/setup.config
RUN sed -i -e "s|db_jdbc_library_path\=|db_jdbc_library_path\=\/opt\/edb\/connectors\/jdbc\/edb-*17.jar|g" /opt/engine/server/setup.config
RUN sed -i -e "s/db_admin_user_name\=sa/db_admin_user_name\=enterprisedb/g" /opt/engine/server/setup.config
RUN sed -i -e "s/db_admin_password\=/db_admin_password\=Fujitsu1/g" /opt/engine/server/setup.config
RUN sed -i -e "s|db_data_file_location\=|db_data_file_location\=\/opt\/edb\/9.5AS\/data|g" /opt/engine/server/setup.config
RUN sed -i -e 's/database_creation_selection\=0/database_creation_selection\=1/g' /opt/engine/server/setup.config
RUN echo "db_name=ibpmdb" >>/opt/engine/server/setup.config
RUN echo "postgres_home=/opt/edb/9.5AS" >>/opt/engine/server/setup.config
RUN sed -i -e "s/^PASSWORD\=/PASSWORD\=Fujitsu1/g" /opt/engine/server/deployment/dbsetup/postgresql/config.sh
RUN sed -i -e "s|POSTGRES_HOME\=|POSTGRES_HOME\=\/opt\/edb\/9.5AS|g" /opt/engine/server/deployment/dbsetup/postgresql/config.sh
RUN sed -i -e "s/DB_ADMIN_USER\=/DB_ADMIN_USER\=enterprisedb/g" /opt/engine/server/deployment/dbsetup/postgresql/config.sh
RUN sed -i -e "s/DB_ADMIN_PASSWORD\=/DB_ADMIN_PASSWORD\=Fujitsu1/g" /opt/engine/server/deployment/dbsetup/postgresql/config.sh
RUN sed -i -e "s/PORT\=/PORT\=5444/g" /opt/engine/server/deployment/dbsetup/postgresql/config.sh

USER enterprisedb
ENTRYPOINT ["/init.sh"]
CMD ["/bin/bash"]