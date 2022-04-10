#!/bin/bash

export BUCKET_NAME=${bucket_name}
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

export DEBIAN_FRONTEND=noninteractive && \
  sudo apt-get update && \
  sudo apt-get -y install awscli nfs-common

sudo mkdir -p $MOUNT_LOCATION
echo "$MOUNT_TARGET:/ $MOUNT_LOCATION nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0" >> /etc/fstab
mount -a

cd /root
aws s3 cp s3://$BUCKET_NAME/docker-compose.yml .
# TODO:
# install docker & docker compose
# docker-comppose up --detach
