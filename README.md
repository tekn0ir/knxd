## KNXD Dockerfile


This repository contains **Dockerfile** of KNXD

### Base Docker Image

* [debian](https://hub.docker.com/_/debian/)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Download: `docker pull tekn0ir/knxd`

   (alternatively, you can build an image from Dockerfile: `docker build -t="tekn0ir/knxd" github.com/tekn0ir/knxd`)


### Usage

    docker run -d -p 0.0.0.0:6720:6720 -v /path/to/config.ini:/another/path/to/config.ini tekn0ir/knxd /another/path/to/config.ini

[config documentantion] (https://github.com/knxd/knxd/blob/master/doc/inifile.rst)