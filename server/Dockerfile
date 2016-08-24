FROM centos:7
MAINTAINER Christophe Gattardi <christophe.gattardi@gmail.com>

ENV ORCL_URL=http://192.168.99.1/oracle \
    ORACLE_BASE=/opt/oracle \
    ORACLE_HOME=/opt/oracle/product/12.1.0/dbhome_1

# System update and Pre-requisite install
RUN yum -y update && \
    yum -y install unzip binutils compat-libcap1 compat-libstdc++-33 compat-libstdc++-33.i686 gcc gcc-c++ glibc.i686 glibc glibc-devel glibc-devel.i686 ksh libgcc.i686 libgcc libstdc++ libstdc++.i686 libstdc++-devel libstdc++-devel.i686 libaio libaio.i686 libaio-devel libaio-devel.i686 libXext libXext.i686 libXtst libXtst.i686 libX11 libX11.i686 libXau libXau.i686 libxcb libxcb.i686 libXi libXi.i686 make sysstat vte3 smartmontools wget && \
    yum clean all && \
    # Preparing system
    groupadd -g 500 dba && \
    groupadd -g 501 oinstall && \
    useradd -d /home/oracle -g dba -G oinstall,dba -m -s /bin/bash oracle && \
	  mkdir -p $ORACLE_BASE && \
	  chown -R oracle:dba $ORACLE_BASE

COPY etc/30-oracle.conf /etc/security/limits.d
COPY etc/sysctl.conf /etc/sysctl.conf
COPY etc/profile_oracle.sh /etc/profile.d/oracle.sh
COPY etc/instSwOnly.rsp /tmp/instSwOnly.rsp

# Oracle installation
USER oracle
RUN mkdir -p /tmp/install && \
    cp /tmp/instSwOnly.rsp /tmp/install/ && \
	  sed -i -e "s|###ORACLE_BASE###|$ORACLE_BASE|g" /tmp/install/instSwOnly.rsp && \
    sed -i -e "s|###ORACLE_HOME###|$ORACLE_HOME|g" /tmp/install/instSwOnly.rsp && \
    cd /tmp/install && \
    wget -q $ORCL_URL/linuxamd64_12102_database_1of2.zip && \
    wget -q $ORCL_URL/linuxamd64_12102_database_2of2.zip && \
    unzip linuxamd64_12102_database_1of2.zip && \
    unzip linuxamd64_12102_database_2of2.zip && \
    rm *.zip && \
    cd /tmp/install/database/ && \
    ./runInstaller -ignoreSysPrereqs -ignorePrereq -silent -force -waitforcompletion -responseFile /tmp/install/instSwOnly.rsp && \
    rm -fr /tmp/install

# Oracle root scripts and chaperone installation
USER root
RUN rm /tmp/instSwOnly.rsp && \
    $ORACLE_BASE/oraInventory/orainstRoot.sh && \
    $ORACLE_HOME/root.sh && \
    sed -i -e "s|###ORACLE_BASE###|$ORACLE_BASE|g" /etc/profile.d/oracle.sh && \
    sed -i -e "s|###ORACLE_HOME###|$ORACLE_HOME|g" /etc/profile.d/oracle.sh && \
    yum -y install epel-release && \
    yum -y install python34 python34-devel && \
    yum -y install jq && \
    yum clean all && \
    curl https://bootstrap.pypa.io/get-pip.py | python3.4 && \
    pip3 install chaperone

# Oracle launch process
COPY chaperone.d/*.conf /etc/chaperone.d/
COPY sbin/* /opt/tools/sbin/
COPY bin/* /opt/tools/bin/
COPY etc/orclopts.json /opt/tools/etc/
RUN chmod 755 /opt/tools/sbin/* /opt/tools/bin/*

# Post installation task to enable/disable oracle options
USER oracle
RUN /opt/tools/bin/orclopts.sh

USER root

EXPOSE 1521 5500

CMD ["/usr/bin/chaperone"]
