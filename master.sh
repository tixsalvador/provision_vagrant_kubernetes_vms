#!/bin/sh

IP=`hostname -I | awk '{print $2}'`
POD_NETWORK=10.244.0.0/16

echo "Building cluster"
kubeadm init --pod-network-cidr $POD_NETWORK --apiserver-advertise-address $IP > /dev/null 2>&1
sudo -u vagrant mkdir -p $HOME/.kube
sudo -u vagrant /bin/cp -if /etc/kubernetes/admin.conf $HOME/.kube/config
sudo -u vagrant chown $(id -u):$(id -g) $HOME/.kube/config
sudo -u vagrant kubectl apply -f https://raw.githubusercontent.com/tixsalvador/ansible_vagrant/master/files/kube-flannel.yml > /dev/null 2>&1
