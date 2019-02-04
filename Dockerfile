FROM flannon/circleci-centos7-core

MAINTAINER Flannon Jackson <flannon@5eight5.com>

# Install needed software and users
USER root
# RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
ENV container docker
RUN yum -y update; yum clean all
RUN yum -y install systemd && yum clean all && \
    (cd /lib/systemd/system/sysinit.target.wants/; \ 
      for i in *; do \
        [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; \
      done) && \
    rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/* && \
    yum install -y python2-devel && \
    yum install -y centos-release-scl && \
    yum install -y gcc make python27 python27-python-pip python2-pip && \
    yum install -y device-mapper-persistent-data lvm2 && \
    yum -y update && yum clean all -y
    #yum install https://download.docker.com/linux/centos/docker-ce.repo && \
RUN scl_source enable python27 && \
    pip install pip --upgrade && \
    pip install boto3 && \
    pip install ansible molecule docker-py && \
    echo "#!/bin/bash\nsource scl_source enable python27" \
    > /etc/profile.d/enablepython27.sh

VOLUME [ “/sys/fs/cgroup” ]
CMD ["/usr/sbin/init"]
USER circleci
