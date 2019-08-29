FROM balenalib/raspberrypi3-debian:buster

LABEL mantainer="Anders Åslund <teknoir@teknoir.se>" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="raspbian-homebridge" \
    org.label-schema.description="Docker running debian and knxd" \
    org.label-schema.url="https://www.teknoir.se" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/tekn0ir" \
    org.label-schema.vendor="Anders Åslund" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0"

RUN [ "cross-build-start" ]

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
      libfmt-dev \
      gosu \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/*

# and get the source code
WORKDIR /root
RUN git clone https://github.com/knxd/knxd.git \
 && cd knxd \
 && git checkout master \
 && dpkg-buildpackage -b -uc \
 && cd .. \
 && dpkg -i knxd_*.deb knxd-tools_*.deb \
 && rm /root/*.deb \
 && rm /root/*.changes \
 && rm /root/*.tar.gz \
 && rm -rf /root/knxd \
 && rm -rf /usr/share/locale/* \
 && rm -rf /var/cache/debconf/*-old \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /usr/share/doc/*

ADD config.ini /config.ini

ENV GOSU_NAME docker

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh  \
    && sed -i -e 's/\r$//' /entrypoint.sh

COPY cmd.sh /
RUN chmod +x /cmd.sh  \
    && sed -i -e 's/\r$//' /cmd.sh

RUN [ "cross-build-end" ]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/cmd.sh"]
