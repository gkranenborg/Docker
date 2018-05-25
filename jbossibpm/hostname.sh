#!/bin/bash

OLDHOSTNAME=`grep FQDN /opt/engine/server/instance/default/console/conf/console.conf|awk '{print $3}'`
NEWHOSTNAME=`hostname -s`

if [ "$OLDHOSTNAME" != "$NEWHOSTNAME" ]
then
	UPPEROLDHOST=`echo $OLDHOSTNAME|tr [a-z] [A-Z]`
	UPPERNEWHOST=`echo $NEWHOSTNAME|tr [a-z] [A-Z]`
	sed -i -e "s/<property name=\"message.selector\" value=\"$UPPEROLDHOST\"/<property name=\"message.selector\" value=\"$UPPERNEWHOST\"/g" /opt/jboss-eap-6.4/domain/configuration/host.xml
	sed -i -e "s/$OLDHOSTNAME/$NEWHOSTNAME/g" /opt/engine/server/instance/default/console/conf/console.conf
	sed -i -e "s/$OLDHOSTNAME/$NEWHOSTNAME/g" /opt/engine/client/iFlowClient.properties
	sed -i -e "s/$OLDHOSTNAME/$NEWHOSTNAME/g" /opt/jboss-eap-6.4/domain/configuration/host.xml
	sed -i -e "s/$OLDHOSTNAME/$NEWHOSTNAME/g" /opt/jboss-eap-6.4/domain/configuration/domain.xml

	export PGPASSWORD=Fujitsu1
	/opt/edb/9.5AS/bin/psql -U enterprisedb -d ibpmdb -c "\copy ibpmproperties to '/tmp/bpmprop' csv;"
	sed -i -e "s/$OLDHOSTNAME/$NEWHOSTNAME/g" /tmp/bpmprop
	/opt/edb/9.5AS/bin/psql -U enterprisedb -d ibpmdb -c "delete from ibpmproperties"
	/opt/edb/9.5AS/bin/psql -U enterprisedb -d ibpmdb -c "\copy ibpmproperties from '/tmp/bpmprop' csv;"
fi

if [ -f /opt/AgileAdapterData/iFlowClient.properties ]
then
	sed -i -e "s/interstagedemo/$NEWHOSTNAME/g" /opt/AgileAdapterData/iFlowClient.properties
	sed -i -e "s/$OLDHOSTNAME/$NEWHOSTNAME/g" /opt/AgileAdapterData/iFlowClient.properties
fi
if [ -f /opt/SSOFI_Sessions/EmailNotification.properties ]
then
	sed -i -e "s/interstagedemo/$NEWHOSTNAME/g" /opt/SSOFI_Sessions/EmailNotification.properties
	sed -i -e "s/127.0.0.1/$NEWHOSTNAME/g" /opt/SSOFI_Sessions/EmailNotification.properties
	sed -i -e "s/$OLDHOSTNAME/$NEWHOSTNAME/g" /opt/SSOFI_Sessions/EmailNotification.properties
fi
if [ -f /opt/AgileAdapterData/EmailNotification.properties ]
then
	sed -i -e "s/interstagedemo/$NEWHOSTNAME/g" /opt/SSOFI_Sessions/EmailNotification.properties
	sed -i -e "s/127.0.0.1/$NEWHOSTNAME/g" /opt/SSOFI_Sessions/EmailNotification.properties
	sed -i -e "s/$OLDHOSTNAME/$NEWHOSTNAME/g" /opt/SSOFI_Sessions/EmailNotification.properties
fi
if [ -f /opt/AgileAdapterData/Analytics.properties ]
then
	sed -i -e "s/interstagedemo/$NEWHOSTNAME/g" /opt/AgileAdapterData/Analytics.properties
	sed -i -e "s/$OLDHOSTNAME/$NEWHOSTNAME/g" /opt/AgileAdapterData/Analytics.properties
fi
if [ -f /opt/SSOFI_Sessions/config.txt ]
then
	sed -i -e "s/interstagedemo/$NEWHOSTNAME/g" /opt/SSOFI_Sessions/config.txt
	sed -i -e "s/127.0.0.1/$NEWHOSTNAME/g" /opt/SSOFI_Sessions/config.txt
	sed -i -e "s/$OLDHOSTNAME/$NEWHOSTNAME/g" /opt/SSOFI_Sessions/config.txt
fi
if [ -f /opt/PostHocData/Config.properties ]
then
	sed -i -e "s/interstagedemo/$NEWHOSTNAME/g" /opt/PostHocData/Config.properties
	sed -i -e "s/127.0.0.1/$NEWHOSTNAME/g" /opt/PostHocData/Config.properties
	sed -i -e "s/$OLDHOSTNAME/$NEWHOSTNAME/g" /opt/PostHocData/Config.properties
fi