FROM ubuntu

LABEL maintainer="Michael Buluma"

ARG DEBIAN_FRONTEND=noninteractive

# ENV pip_packages "ansible"

# Install dependencies.
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  systemd systemd-sysv dbus dbus-user-session
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
