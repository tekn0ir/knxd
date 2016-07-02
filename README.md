# knxd
KNXD Dockerfile.


## KNXD Dockerfile


This repository contains **Dockerfile** of KNXD

### Base Docker Image

* [debian](https://hub.docker.com/_/debian/)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Download: `docker pull tekn0ir/knxd`

   (alternatively, you can build an image from Dockerfile: `docker build -t="tekn0ir/knxd" github.com/tekn0ir/knxd`)


### Usage

    docker run -d -p 0.0.0.0:6720:6720 -e "EIBADDR=1.1.128" -e "LISTEN_TCP=6720" -e "IPTN=10.0.1.6" tekn0ir/knxd
