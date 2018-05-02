#!/bin/bash

/opt/edb/9.5AS/bin/pg_ctl start -D /opt/edb/9.5AS/data
exec "$@"