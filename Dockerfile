FROM debian:jessie

MAINTAINER Anders Åslund <anders.aslund@teknoir.se>

# Update packages
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y git-core build-essential wget debhelper cdbs autoconf automake libtool libusb-1.0-0 libusb-1.0-0-dev pkg-config libsystemd-daemon-dev dh-systemd init-system-helpers && \
  apt-get clean -y && \
  apt-get autoclean -y && \
  apt-get autoremove

# and get the source code
WORKDIR /root
RUN git clone https://github.com/knxd/knxd.git

# knxd requires libpthsem which unfortunately isn't part of Debian
COPY pthsem_2.0.8.tar.gz /root/pthsem_2.0.8.tar.gz
RUN tar xzf pthsem_2.0.8.tar.gz
WORKDIR /root/pthsem-2.0.8
RUN sleep 1
RUN dpkg-buildpackage -b -uc
WORKDIR /root
RUN sleep 1
RUN dpkg -i libpthsem*.deb

# now build+install knxd itself
WORKDIR /root/knxd
RUN sleep 1
RUN dpkg-buildpackage -b -uc
WORKDIR /root
RUN sleep 1
RUN dpkg -i knxd_*.deb knxd-tools_*.deb

# clean up
RUN rm /root/*.deb && \
  rm /root/*.changes && \
  rm /root/*.tar.gz && \
  rm -rf /root/knxd && \
  rm -rf /root/pthsem-2.0.8 && \
  rm -rf /usr/share/locale/* && \
  rm -rf /var/cache/debconf/*-old && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /usr/share/doc/*

ENV EIBADDR 1.1.128
ENV LISTEN_TCP 6720
ENV IPTN 10.0.1.6

EXPOSE ${LISTEN_TCP}

USER knxd

CMD knxd --eibaddr=${EIBADDR} -u /tmp/eib -D -T -R -S --listen-tcp=${LISTEN_TCP} iptn:${IPTN}
