## KNXD Dockerfile


This repository contains **Dockerfile** of KNXD

### Base Docker Image

* [ubuntu](https://hub.docker.com/_/ubuntu) 20.04


### Installation

1. Install [Docker](https://www.docker.com/).

2. Download: `docker pull tekn0ir/knxd`

   (alternatively, you can build an image from Dockerfile: `docker build -t="tekn0ir/knxd" github.com/tekn0ir/knxd`)


### Usage

    docker run -d -p 0.0.0.0:6720:6720 -v /path/to/config.ini:/another/path/to/config.ini tekn0ir/knxd /another/path/to/config.ini

### config.ini

config.ini file documentation can be found on the KNXD site: 
[config documentantion](https://github.com/knxd/knxd/blob/master/doc/inifile.rst)

### docker-compose
A sampe docker-compose.yml could look like this and will map your custom config.ini into the container.

```yaml
version: '3.4'
services:
  knxd:
    image: renehezser/knxd
    container_name: knxd
    volumes:
      - /mnt/knxd/config.ini:/config.ini
    ports:
      - 6720:6720
      - 3671:3671
    restart: always
    network_mode: host
```