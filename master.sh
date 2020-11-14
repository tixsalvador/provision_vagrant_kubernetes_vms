#!/bin/sh

IP=`hostname -I | awk '{print $2}'`
POD_NETWORK=10.244.0.0/16

echo "Building cluster"
kubeadm init --pod-network-cidr $POD_NETWORK --apiserver-advertise-address $IP
kubectl apply -f https://raw.githubusercontent.com/tixsalvador/ansible_vagrant/master/files/kube-flannel.yml
