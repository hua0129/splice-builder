#!/bin/bash

echo "Starting Spark ..."
/opt/spark/sbin/start-master.sh
/opt/spark/sbin/start-slave.sh spark://localhost:7078

echo "Starting Longdb ..."
/opt/longdb/start-splice-cluster -b -s -1  -p "cdh5.14.0" 2> /dev/null

if [ -d /opt/data/db_init ] ; then
    echo "Initializing database ..."
    /opt/data/db_init/init.sh
    rm -rf /opt/data/db_init
fi
