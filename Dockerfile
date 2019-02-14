FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
# FROM debian:jessie

MAINTAINER Anders Åslund <anders.aslund@teknoir.se>

# Update packages
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
      git-core \
      cmake \
      build-essential \
      wget \
      curl \
      debhelper \
      cdbs \
      autoconf \
      automake \
      libtool \
      libusb-1.0-0 \
      libusb-1.0-0-dev \
      pkg-config \
      libsystemd-dev \
      dh-systemd \
      init-system-helpers \
      libev-dev \
      libsystemd-dev \
      systemd \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && apt-get autoremove

RUN curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64" && \
	echo "6f3a72f474cafacb3c7b4a7397a1f37d82fcc27b596cbb66e4ea0a8ee92eee76  /usr/local/bin/gosu" | sha256sum -c && \
	chmod +x /usr/local/bin/gosu

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
RUN git checkout master
RUN dpkg-buildpackage -b -uc
WORKDIR /root
RUN sleep 1
RUN echo HIER
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

ADD config.ini /config.ini

ENV GOSU_NAME docker

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh  \
    && sed -i -e 's/\r$//' /entrypoint.sh

COPY cmd.sh /
RUN chmod +x /cmd.sh  \
    && sed -i -e 's/\r$//' /cmd.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/cmd.sh"]
