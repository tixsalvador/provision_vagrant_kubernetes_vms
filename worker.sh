#!/bin/sh

MASTER=10.10.10.10

echo "Adding to cluster"
sshpass  -p vagrant  ssh  -o "StrictHostKeyChecking no" vagrant@$MASTER 'sudo kubeadm token create --print-join-command' > /root/join
chmod +x /root/join
/usr/bin/sh /root/join > /dev/null 2>&1
