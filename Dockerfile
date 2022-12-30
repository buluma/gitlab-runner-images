FROM centos:8

LABEL maintainer="Michael Buluma <bulumaknight@gmail.com>"
LABEL build_date="2022-04-11"

ENV container=docker

ENV container=docker

# Install requirements.
RUN yum -y install sudo systemd systemd-sysv dbus \
 && yum -y update \
 && yum -y install \
      initscripts \
      which \
      hostname \
      python3 \
      python3-pip \
      python3-pyyaml \
 && yum clean all

RUN cd /lib/systemd/system/sysinit.target.wants/ ; \
    for i in * ; do [ $i = systemd-tmpfiles-setup.service ] || rm -f $i ; done ; \
    rm -f /lib/systemd/system/multi-user.target.wants/* ; \
    rm -f /etc/systemd/system/*.wants/* ; \
    rm -f /lib/systemd/system/local-fs.target.wants/* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* ; \
    rm -f /lib/systemd/system/basic.target.wants/* ; \
    rm -f /lib/systemd/system/anaconda.target.wants/*

# Use the archive repository, since CentOS 8 is end of life.
RUN sed -i 's|mirrorlist|#mirrorlist|g' /etc/yum.repos.d/CentOS-* ; \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

VOLUME ["/sys/fs/cgroup"]

CMD ["/sbin/init"]
