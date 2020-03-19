#!/bin/bash


splice_version=2.7.0.1929
longdb_version=v1.1.5

docker build -t longdb/longdb_base:latest -f base/Dockerfile .

wget https://github.com/splicemachine/spliceengine/archive/${splice_version}.tar.gz 

wget https://archive.apache.org/dist/spark/spark-$spark_version/spark-$spark_version-bin-hadoop2.6.tgz

docker pull longdb/longdb:latest

cp Dockerfile Dockerfile_build

sed -i 's/2.7.0.1929/${splice_version}/g' ./Dockerfile_build

docker build -t longdb/longdb:${longdb_version} -f Dockerfile_build .
