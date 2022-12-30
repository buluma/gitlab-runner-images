FROM alpine:3

LABEL maintainer="Michael Buluma <bulumaknight@gmail.com>"
LABEL build_date="2022-05-18"

ENV container=docker

# Enable init.
RUN apk add --update --no-cache openrc && \
    sed -i 's/^\(tty\d\:\:\)/#\1/g' /etc/inittab && \
    sed -i \
      -e 's/#rc_sys=".*"/rc_sys="docker"/g' \
      -e 's/#rc_env_allow=".*"/rc_env_allow="\*"/g' \
      -e 's/#rc_crashed_stop=.*/rc_crashed_stop=NO/g' \
      -e 's/#rc_crashed_start=.*/rc_crashed_start=YES/g' \
      -e 's/#rc_provide=".*"/rc_provide="loopback net"/g' \
      /etc/rc.conf && \
    rm -f /etc/init.d/hwdrivers \
      /etc/init.d/hwclock \
      /etc/init.d/hwdrivers \
      /etc/init.d/modules \
      /etc/init.d/modules-load \
      /etc/init.d/modloop && \
    sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh && \
    sed -i 's/VSERVER/DOCKER/Ig' /lib/rc/sh/init.sh

# Enable DBUS
# Add Required Packages [Layer 1]
RUN apk update && \
    apk add \
      ca-certificates \
      dbus \
      dbus-dev \
      g++ \
      git

# Download Sources [Layer 2]
RUN cd ~ && \
    git clone https://github.com/makercrew/dbus-sample.git --recursive && \
    cd dbus-sample/ && \
    g++ dbus.cpp -std=c++0x $(pkg-config dbus-1 --cflags) -ldbus-1 -Werror -Wall -Wextra

# Verify Build and Install
CMD dbus-daemon --system --nofork

VOLUME ["/sys/fs/cgroup"]

CMD ["/sbin/init"]
