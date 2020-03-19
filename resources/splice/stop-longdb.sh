#!/bin/bash

/opt/longdb/start-splice-cluster -k

/opt/spark/sbin/stop-master.sh

/opt/spark/sbin/stop-slave.sh 
