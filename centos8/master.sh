#!/bin/sh

IP=`hostname -I | awk '{print $2}'`
POD_NETWORK=10.244.0.0/16

echo "Setting up NFS"
dnf install -y nfs-utils > /dev/null 2>&1
systemctl enable nfs-server > /dev/null 2>&1
systemctl start nfs-server
mkdir -p /mnt/nfs/{data,content}
mkdir -p /mnt/nfs/data/{mysql0,mysql1,mysql2,etcd0,etcd1,etcd2}
chmod -R 777 /mnt/nfs
cat > /etc/exports <<- "EOF"
/mnt/nfs/data  10.10.10.0/24(rw,sync,no_subtree_check)
/mnt/nfs/content  10.10.10.0/24(rw,sync,no_subtree_check,no_root_squash)
EOF
exportfs -a

echo "Building cluster"
kubeadm init --pod-network-cidr $POD_NETWORK --apiserver-advertise-address $IP > /dev/null 2>&1
mkdir -p $HOME/.kube
/bin/cp -if /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://raw.githubusercontent.com/tixsalvador/ansible_vagrant/master/files/kube-flannel.yml > /dev/null 2>&1
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Fix "kubectl get cs" command give nodes on unhealthy state. connect: connection refused error
 sed '/--port=0/s/^/#/' /etc/kubernetes/manifests/kube-scheduler.yaml -i
 sed '/--port=0/s/^/#/' /etc/kubernetes/manifests/kube-controller-manager.yaml -i
 systemctl restart kubelet
