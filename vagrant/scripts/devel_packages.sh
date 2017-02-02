#!/usr/bin/env bash

apt-get update
apt-get install -y unzip htop tmux git build-essential python-pip python3-pip jq

pip install influxdb
pip3 install influxdb
