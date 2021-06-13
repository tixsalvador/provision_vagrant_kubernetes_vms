#!/bin/sh

MASTER=10.10.10.10

echo "Mounting NFS"
mkdir /mnt/data
sed -i "$ a $MASTER:/mnt/nfs /mnt/data nfs   rw,sync,hard,intr 0 0" /etc/fstab
mount -a

echo "Adding to cluster"
sshpass  -p vagrant  ssh  -o "StrictHostKeyChecking no" vagrant@$MASTER 'sudo kubeadm token create --print-join-command' > /root/join
chmod +x /root/join
/usr/bin/sh /root/join > /dev/null 2>&1
