#!/bin/bash

set -x

#splice_version=2.8.0.1929
splice_version=2.8.0.1946
wget https://github.com/splicemachine/spliceengine/archive/$splice_version.tar.gz
tar -zxvf $splice_version.tar.gz

sed -i "s/splice>/longdb>/" spliceengine-$splice_version/db-tools-ij/src/main/java/com/splicemachine/db/impl/tools/ij/utilMain.java

#<url>http://repository.apache.org/snapshots/</url>
#<url>http://maven.aliyun.com/nexus/content/repositories/snapshots/</url>

sed -i "s:repository.apache.org/snapshots:maven.aliyun.com/nexus/content/repositories/snapshots:" ./spliceengine-$splice_version/pom.xml

./spliceengine-$splice_version/start-splice-cluster -p "cdh5.14.0"

./spliceengine-$splice_version/start-splice-cluster -k


echo docker build ..............


cat > Dockerfile <<EOF
FROM alpine
ADD spliceengine-$splice_version /opt/
ENTRYPOINT ["/bin/sh"]
EOF


DOCKER_PASSWORD=hhuuaaxr_123
DOCKER_USERNAME=hua0129

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
#docker pull centos
docker build -t hua0129/spliceengine:$splice_version .
docker images
docker push hua0129/spliceengine:$splice_version

tar -zcvf m2.tar.gz -C ~ .m2

cat > Dockerfile <<EOF
FROM circleci/openjdk:8u212-jdk-stretch
ADD m2.tar.gz /home/circleci/
EOF
docker build -t hua0129/spliceengine-m2:$splice_version .
docker push hua0129/spliceengine-m2:$splice_version

echo "=================end=================="
