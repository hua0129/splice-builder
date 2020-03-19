FROM longdb/longdb:latest as prebuild

FROM longdb/longdb_base:latest as build
MAINTAINER XiaoRu Hua <xrhua@longdb.com>

ARG longdb_version=1.0.0
ARG splice_version=2.7.0.1929
ARG spark_version=2.2.2
# ENV SPLICE_SOURCE_URI=https://github.com/splicemachine/spliceengine/archive/2.7.0.1929.tar.gz
ENV SPLICE_SOURCE_URI=spliceengine-2.7.0.1929.tar.gz

ENV SPLICE_DEP_JAR_PATH=/opt/longdb/platform_it/target/dependency/

ENV JAVA_HOME=/etc/alternatives/jre

WORKDIR /opt

# RUN curl -kLs http://www-eu.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz | tar -xz -C /opt  \
COPY --from=prebuild /opt /opt
COPY --from=prebuild /root/.m2 /root/.m2
RUN rm -rf /opt/longdb-1.0.0 \
 && rm -f  /opt/longdb \
 && rm -rf /opt/hadoop \
 && rm -rf /opt/spark \
 && rm -rf /opt/data

# RUN curl -kLs $SPLICE_SOURCE_URI | tar -xz -C /opt  \
COPY resources/$SPLICE_SOURCE_URI /opt
RUN tar -xzf $SPLICE_SOURCE_URI -C /opt  \
 &&  mv /opt/spliceengine-$splice_version /opt/longdb-$longdb_version \
 &&  ln -s /opt/longdb-$longdb_version /opt/longdb  \
 &&  sed -i "s/splice>/longdb>/" /opt/longdb/db-tools-ij/src/main/java/com/splicemachine/db/impl/tools/ij/utilMain.java \
 &&  cd /opt/longdb  \
 &&  ./start-splice-cluster -p "cdh5.14.0"  \
 &&  ./start-splice-cluster -k \
 && rm -f *.gz

COPY resources/splice /opt

# RUN curl -kLs $SPLICE_SHELL_URI | tar -xz -C /opt
RUN  cp /opt/longdb/db-tools-ij/target/db-tools-ij-$splice_version.jar /opt/sqlshell/lib/ \
 && cp /opt/longdb/db-client/target/db-client-$splice_version.jar /opt/sqlshell/lib/ \
 && cp /opt/longdb/db-engine/target/db-engine-$splice_version.jar /opt/sqlshell/lib/ 

# RUN curl -kLsO  https://archive.apache.org/dist/spark/spark-$spark_version/spark-$spark_version-bin-hadoop2.6.tgz  \
COPY resources/spark-$spark_version-bin-hadoop2.6.tgz /opt
RUN echo spark-$spark_version-bin-hadoop2.6.tgz  \
 &&   tar -xzf spark-$spark_version-bin-hadoop2.6.tgz  \
 &&   mv spark-$spark_version-bin-hadoop2.6 /opt/spark   \
 &&   cp /opt/spark/conf/spark-env.sh.template /opt/spark/conf/spark-env.sh  \
 &&   echo 'SPARK_MASTER_PORT=7078' >> /opt/spark/conf/spark-env.sh  \
 &&   echo 'SPARK_MASTER_WEBUI_PORT=8091' >> /opt/spark/conf/spark-env.sh  \
 &&   echo 'SPARK_WORKER_INSTANCES=2' >> /opt/spark/conf/spark-env.sh  \
 &&   echo 'SPARK_WORKER_CORES=2' >> /opt/spark/conf/spark-env.sh  \
 &&   echo 'SPARK_WORKER_MEMORY=2g' >> /opt/spark/conf/spark-env.sh \
 && rm -f *gz

RUN cd $SPLICE_DEP_JAR_PATH/  \
 &&   cp splice_access_api-$splice_version.jar /opt/spark/jars/  \
 &&   cp splice_encoding-$splice_version.jar /opt/spark/jars/  \
 &&   cp splice_machine-$splice_version.jar /opt/spark/jars/  \
 &&   cp splice_protocol-$splice_version.jar /opt/spark/jars/  \
 &&   cp splice_si_api-$splice_version.jar /opt/spark/jars/  \
 &&   cp splice_timestamp_api-$splice_version.jar /opt/spark/jars/  \
 &&   cp db-client-$splice_version.jar  /opt/spark/jars/  \
 &&   cp db-engine-$splice_version.jar  /opt/spark/jars/  \
 &&   cp hbase_storage-cdh5.14.0-$splice_version.jar /opt/spark/jars/  \
 &&   cp hbase_pipeline-cdh5.14.0-$splice_version.jar  /opt/spark/jars/  \
 &&   cp utilities-$splice_version.jar /opt/spark/jars/  \
 &&   cp pipeline_api-$splice_version.jar /opt/spark/jars/  \
 &&   cp concurrentlinkedhashmap-lru-1.4.2.jar  /opt/spark/jars/  \
 &&   cp hbase_sql-cdh5.14.0-$splice_version.jar /opt/spark/jars/   \
 &&   cp /opt/longdb/splice_spark/target/splicemachine-cdh5.14.0-2.2.0.cloudera2_2.11-2.7.0.1929.jar  /opt/spark/jars/  \
 &&   cp hadoop-common-2.6.0-cdh5.14.0.jar /opt/spark/jars/hadoop-common-2.6.0-cdh5.14.0.jar  \
 &&   cp hbase-protocol-1.2.0-cdh5.14.0.jar /opt/spark/jars/hbase-protocol-1.2.0-cdh5.14.0.jar  \
 &&   cp hbase-client-1.2.0-cdh5.14.0.jar /opt/spark/jars/hbase-client-1.2.0-cdh5.14.0.jar  \
 &&   cp hbase-common-1.2.0-cdh5.14.0.jar /opt/spark/jars/hbase-common-1.2.0-cdh5.14.0.jar  \
 &&   cp hbase-server-1.2.0-cdh5.14.0.jar /opt/spark/jars/hbase-server-1.2.0-cdh5.14.0.jar  \
 &&   cp htrace-core-3.2.0-incubating.jar /opt/spark/jars/htrace-core-3.2.0-incubating.jar  \
 &&   cp htrace-core4-4.0.1-incubating.jar /opt/spark/jars/htrace-core4-4.0.1-incubating.jar  \
 &&   cp metrics-core-2.1.2.jar /opt/spark/jars/metrics-core-2.1.2.jar  \
 &&   cp sketches-core-0.8.4.jar  /opt/spark/jars/sketches-core-0.8.4.jar  \
 &&   cp kryo-serializers-0.38.jar /opt/spark/jars/kryo-serializers-0.38.jar  \
 &&   cp lucene-core-4.3.1.jar /opt/spark/jars/lucene-core-4.3.1.jar  \
 &&   cp hbase-hadoop-compat-1.2.0-cdh5.14.0.jar /opt/spark/jars/hbase-hadoop-compat-1.2.0-cdh5.14.0.jar

RUN mkdir -p /opt/hadoop/conf  \
 &&   cp /opt/longdb/assembly/standalone/template/conf/core-site.xml /opt/hadoop/conf/core-site.xml  \
 &&   cp /opt/longdb/platform_it/target/hbase-site.xml /opt/hadoop/conf/hbase-site.xml  \
 &&   cp /opt/longdb/assembly/standalone/template/conf/yarn-site.xml /opt/hadoop/conf/yarn-site.xml  \
 &&   echo 'HADOOP_CONF_DIR=/opt/hadoop/conf' >> /opt/spark/conf/spark-env.sh

RUN /opt/start-longdb.sh  \ 
 && /opt/stop-longdb.sh 

RUN rm -f /opt/*gz \
 && find /opt/ -name "*~" | xargs rm -f \
 && find /opt/ -name "*.swp" | xargs rm -f

# ----------------------------------------------------------------------------------------------------------------------------------------
FROM longdb/longdb_base:latest 

MAINTAINER XiaoRu Hua <xrhua@longdb.com>

WORKDIR /opt

ENV JAVA_HOME=/etc/alternatives/jre

COPY --from=build /opt /opt
COPY --from=build /root/.m2 /root/.m2

RUN ln -s /opt/maven/bin/mvn /usr/bin/mvn \
 && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
 && sed -i '1s/python.*$/python2.7/' /usr/bin/yum \
 && sed -i '1s/python.*$/python2.7/' /usr/libexec/urlgrabber-ext-down \
 && sed -i '1s/python.*\s/python2.7/' /usr/bin/yum-config-manager

ENTRYPOINT ["/bin/bash"]

EXPOSE 8030 8031 8032 8033 8050 8053 8080
EXPOSE 1527 2181 4040 4041 7077 7078 8091
EXPOSE 8090


