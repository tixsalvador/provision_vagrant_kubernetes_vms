#!/bin/sh
export DEBIAN_FRONTEND=noninteractive

# Enable ssh password login on ssh
echo "Enable ssh password login on ssh"
sed '/^PasswordAuthentication/s/no/yes/' /etc/ssh/sshd_config -i
systemctl restart sshd

# Update all
echo "Update all"
apt-get update -y && apt-get upgrade -y 2>&1

# Install loosends
echo "Install loosends"
apt-get install -y vim net-tools git sshpass tree glusterfs-client wget gnupg2

# Install Docker
echo "Install containerd"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - > /dev/null 2>&1
echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null 2>&1
apt-get update -y
apt-get install containerd -y

# Install kubeadm, kubectl, and kubelet
echo "Install kubeadm, kubectl, and kubelet"
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update -y
apt-get install -y kubectl kubeadm kubelet

IP=`hostname -I | awk '{print $2}'`
sed '/Environment=\"KUBELET_CONFIG_ARGS=/a Environment=\"KUBELET_EXTRA_ARGS=--node-ip='$IP'\"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf -i
systemctl enable kubelet  > /dev/null 2>&1
systemctl daemon-reload
systemctl start kubelet
