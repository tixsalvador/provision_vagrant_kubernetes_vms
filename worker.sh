#!/bin/sh

echo "Adding to cluster"
sshpass  -p vagrant  ssh  -o "StrictHostKeyChecking no" vagrant@10.10.10.100 'sudo kubeadm token create --print-join-command' > /root/join
chmod +x /root/join
/usr/bin/sh /root/join > /dev/null 2>&1
