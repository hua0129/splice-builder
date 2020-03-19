FROM centos:7.4.1708

MAINTAINER XiaoRu Hua <xrhua@longdb.com>

WORKDIR /opt

#COPY resources/* /opt/


ARG RLWRAP_URI=http://rpmfind.net/linux/epel/7/x86_64/Packages/r/rlwrap-0.43-2.el7.x86_64.rpm
 
RUN  yum install -y   --nogpgcheck  net-tools   nc   openssh perl autoconf  curl   unzip   git wget  bind-utils   sed   jq   nc   which   bc   supervisor   java-1.8.0-openjdk-devel   \
 && yum clean all \
 && rm -rf /tmp/* /var/lib/apt/* /var/cache/* /var/log/*



# COPY resources/pip.tar.gz /opt
# RUN tar -xzf pip.tar.gz -C ~

RUN yum install gcc -y
RUN yum install gcc-c++ -y

RUN yum install epel-release -y
RUN yum install python36-devel -y

RUN curl --silent --show-error https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
RUN python3 /tmp/get-pip.py

RUN pip3 install JPype1==0.6.3
RUN pip3 install JayDeBeApi

RUN wget -O pysplice.zip --no-check-certificate https://github.com/splicemachine/pysplice/archive/1.0.0.zip \
 && unzip pysplice.zip \
 && cd pysplice* && pip3 install --no-cache-dir  .

RUN curl -kLs $RLWRAP_URI -O \
     && rpm -ivh *.rpm \
     && rm -f *.rpm 

RUN rm *zip \
 && rm *gz \
 && yum clean all \
 && rm -rf /tmp/* /var/lib/apt/* /var/cache/* /var/log/*

RUN sed -i '1s/python/python2.7/' /usr/bin/yum \
 && sed -i '1s/python/python2.7/' /usr/libexec/urlgrabber-ext-down \
 && sed -i '1s/python/python2.7/' /usr/bin/yum-config-manager

ENTRYPOINT ["/bin/bash"]

