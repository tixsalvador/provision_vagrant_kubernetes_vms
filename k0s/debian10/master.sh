#!/bin/sh

K0CTLGIT="https://github.com/k0sproject/k0sctl/releases/download/v0.9.0/k0sctl-linux-x64"
WORKER1=10.10.10.21

# To suppress the stdin warning message
export DEBIAN_FRONTEND=noninteractive

# Install k0ctl
 wget $K0CTLGIT -O k0ctl && install -o root -m 0755  k0ctl /usr/bin/

# Install kubectl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null 2>&1
apt-get update
apt-get install -y apt-transport-https ca-certificates kubectl
