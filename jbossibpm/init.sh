#!/bin/bash

su enterprisedb -c '/opt/edb/9.5AS/bin/pg_ctl start -D /opt/edb/9.5AS/data'

sleep 10

if [ -f /opt/engine/server/instance/default/console/conf/console.conf ]
then
	HOST_ADDR=$(hostname -i)
	/hostname.sh
else
	HOST_ADDR="127.0.0.1"
fi

HOST_NAME=$(hostname -s)

# some properties to avoid JGroups issues when using cluster/ha profiles
JVM_PROPS="-Djboss.node.name=$HOST_NAME -Djgroups.bind_addr=$HOST_ADDR"
# when using mod_cluster, change the default node name
JVM_PROPS="$JVM_PROPS -Djboss.mod_cluster.jvmRoute=$HOST_NAME -DjvmRoute=$HOST_NAME"

# Starting JBoss.
$JBOSS_HOME/bin/domain.sh -b $HOST_ADDR -bunsecure=$HOST_ADDR -bmanagement=$HOST_ADDR $JVM_PROPS &

exec "$@"