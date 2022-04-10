#!/bin/bash

sudo mkdir /tmp/ssm
cd /tmp/ssm

wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent

rm amazon-ssm-agent.deb

export DEBIAN_FRONTEND=noninteractive && \
  sudo apt-get update && \
  sudo apt-get -y install awscli
