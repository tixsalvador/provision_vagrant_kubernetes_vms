#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
MASTER=10.10.10.20

# Copy ssh key pub from master_deb_k0
mkdir ~/.ssh
chmod 700 ~/.ssh
sshpass  -p vagrant ssh -o "StrictHostKeyChecking no" vagrant@$MASTER 'sudo cat /root/.ssh/id_rsa.pub' | tee -a ~/.ssh/authorized_keys
