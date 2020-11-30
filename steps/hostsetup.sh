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
        libzmq5 \
	python3.8 \
	python3.8-dev \
	python3.8-venv \
	screenfetch

screenfetch

sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2
sudo update-alternatives --config python3

curl https://bootstrap.pypa.io/get-pip.py | sudo python3.8

sudo -H pip3 install git+https://github.com/antmicro/distant-rs.git

curl -o gcloud.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-316.0.0-linux-x86_64.tar.gz

tar xfz gcloud.tar.gz

./google-cloud-sdk/install.sh

gcloud config set project foss-fpga-tools-ext-antmicro

#install Renode

curl -o renode.tar.gz https://dl.antmicro.com/projects/renode/builds/renode-1.11.0+20201125gitc608ee6.linux-portable.tar.gz

sudo mkdir -p /opt/renode
sudo tar xf renode.tar.gz --strip 1 -C /opt/renode
sudo ln -s /opt/renode/renode /usr/bin/renode
sudo ln -s /opt/renode/test.sh /usr/bin/renode-test
sudo -H pip3 install -r /opt/renode/tests/requirements.txt

