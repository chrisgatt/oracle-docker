FROM centos:7
MAINTAINER Christophe Gattardi <christophe.gattardi@gmail.com>

ENV ORCL_URL=http://192.168.99.1/oracle
ENV ORACLI_VER_RPM 12.1.0.2.0-1
ENV ORACLI_VER 12.1
COPY profile_oracle.sh /etc/profile.d
COPY sqlplus.sh /usr/local/bin

# System update and Instant client install (with procobol)
RUN yum -y update && \
    yum -y install unzip wget && \
    yum clean all && \
    # Preparing system
    groupadd -g 500 dba && \
    groupadd -g 501 oinstall && \
    useradd -d /home/oracle -g dba -G oinstall,dba -m -s /bin/bash oracle && \
    chmod 755 /usr/local/bin/sqlplus.sh && \
    yum -y install ${ORCL_URL}/oracle-instantclient${ORACLI_VER}-basic-${ORACLI_VER_RPM}.x86_64.rpm && \
    yum -y install ${ORCL_URL}/oracle-instantclient${ORACLI_VER}-sqlplus-${ORACLI_VER_RPM}.x86_64.rpm && \
    yum -y install ${ORCL_URL}/oracle-instantclient${ORACLI_VER}-devel-${ORACLI_VER_RPM}.x86_64.rpm && \
    yum -y install ${ORCL_URL}/oracle-instantclient${ORACLI_VER}-precomp-${ORACLI_VER_RPM}.x86_64.rpm && \
    rm -rf /var/tmp/yum*

USER oracle
CMD ["/usr/local/bin/sqlplus.sh"]
