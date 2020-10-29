#!/bin/bash

set -e

sudo add-apt-repository ppa:deadsnakes/ppa

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
	python3.8 \
	python3.8-dev \
	python3.8-venv \
	screenfetch

screenfetch

sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2
sudo update-alternatives --config python3

curl https://bootstrap.pypa.io/get-pip.py | sudo python3.8

sudo pip3 install git+https://github.com/antmicro/distant-rs.git
