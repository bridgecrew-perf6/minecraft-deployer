#!/bin/bash

export BUCKET_NAME=${bucket_name}
export DEBIAN_FRONTEND=noninteractive
export MOUNT_LOCATION="${efs_mount_location}"
export MOUNT_TARGET="${efs_dns}"

# Store for reference
echo "export BUCKET_NAME=${bucket_name}" >> /etc/profile
echo "export MOUNT_LOCATION=${efs_mount_location}" >> /etc/profile
echo "export MOUNT_TARGET=${efs_dns}" >> /etc/profile

sudo mkdir /tmp/ssm
cd /tmp/ssm

wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent

rm amazon-ssm-agent.deb

sudo apt-get update && \
sudo apt-get -y install \
  awscli \
  nfs-common \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

sudo mkdir -p $MOUNT_LOCATION
echo "$MOUNT_TARGET:/ $MOUNT_LOCATION nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0" >> /etc/fstab
mount -a

# TODO: Add 1G swap

cd /root
aws s3 cp s3://$BUCKET_NAME/docker-compose.yml .

# INSTALL DOCKER & COMPOSE
# https://docs.docker.com/engine/install/ubuntu/
sudo apt-get remove docker docker-engine docker.io containerd runc
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod a+x /usr/local/bin/docker-compose
# START MINECRAFT
docker-compose up --detach
