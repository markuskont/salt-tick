#!/usr/bin/env bash

apt-get update
apt-get install -y htop tmux git build-essential python-pip python3-pip

pip install influxdb
pip3 install influxdb
