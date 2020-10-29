#!/bin/bash

set -e

echo
echo "========================================"
echo "Host updating packages"
echo "----------------------------------------"
sudo apt -qqy update
echo "----------------------------------------"

echo
echo "========================================"
echo "Host install packages"
echo "----------------------------------------"
sudo apt-get install -y \
        bash \
        build-essential \
        ca-certificates \
        coreutils \
        curl \
        git \
        wget \
	python3 \
	python3-pip

sudo pip3 install git+https://github.com/antmicro/distant-rs.git
