FROM longdb/longdb:v1.1.4 as build
MAINTAINER XiaoRu Hua <xrhua@longdb.com>

WORKDIR /opt

COPY resource/*longdb-admin*.zip /opt/
RUN  unzip *longdb-admin*.zip   \
 &&  rm -f *.zip

COPY resource/longdb-admin /opt/longdb-admin
 
# ----------------------------------------------------------------------------------------------------------------------------------------
FROM longdb/longdb:v1.1.4 

MAINTAINER XiaoRu Hua <xrhua@longdb.com>

WORKDIR /opt

ENV JAVA_HOME=/etc/alternatives/jre

COPY --from=build /opt/longdb-admin /opt/longdb-admin

RUN ln -s /opt/longdb-admin/start.sh /opt/start-admin.sh \
 && ln -s /opt/longdb-admin/stop.sh /opt/stop-admin.sh

ENTRYPOINT ["/bin/bash"]

EXPOSE 8030 8031 8032 8033 8050 8053 8080
EXPOSE 1527 2181 4040 4041 7077 7078 8091
EXPOSE 8090 8088

