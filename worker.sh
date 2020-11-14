#!/bin/sh

MASTER=10.10.10.10

echo "Adding to cluster"
sshpass  -p vagrant  ssh  -o "StrictHostKeyChecking no" vagrant@$MASTER 'sudo kubeadm token create --print-join-command' > /root/join
chmod +x /root/join
/usr/bin/sh /root/join > /dev/null 2>&1
echo "su - vagrant && mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config" 
