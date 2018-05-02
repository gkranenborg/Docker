#!/bin/bash

/opt/edb/9.5AS/bin/pg_ctl start -D /opt/edb/9.5AS/data

HOST_ADDR=$(hostname -i)
HOST_NAME=$(hostname -s)

# some properties to avoid JGroups issues when using cluster/ha profiles
JVM_PROPS="-Djboss.node.name=$HOST_NAME -Djgroups.bind_addr=$HOST_ADDR"
# when using mod_cluster, change the default node name
JVM_PROPS="$JVM_PROPS -Djboss.mod_cluster.jvmRoute=$HOST_NAME -DjvmRoute=$HOST_NAME"

# bind the public interface to 0.0.0.0 due a issue with mod_cluster.
$JBOSS_HOME/bin/domain.sh -b 0.0.0.0 -bunsecure=$HOST_ADDR -bmanagement=$HOST_ADDR $JVM_PROPS

exec "$@"