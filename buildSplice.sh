#!/bin/bash

splice_version=2.8.0.1929
wget https://github.com/splicemachine/spliceengine/archive/2.8.0.1929.tar.gz
tar -zxvf $splice_version.tar.gz

sed -i "s/splice>/longdb>/" spliceengine-$splice_version/db-tools-ij/src/main/java/com/splicemachine/db/impl/tools/ij/utilMain.java

#<url>http://repository.apache.org/snapshots/</url>
#<url>http://maven.aliyun.com/nexus/content/repositories/snapshots/</url>

sed -i "s:repository.apache.org/snapshots:maven.aliyun.com/nexus/content/repositories/snapshots:" ./spliceengine-$splice_version/pom.xml

./spliceengine-$splice_version/start-splice-cluster -p "cdh5.14.0"

./spliceengine-$splice_version/start-splice-cluster -k

echo "=================end=================="
