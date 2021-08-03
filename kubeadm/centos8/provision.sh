#!/bin/sh

# Enable ssh password login on ssh
echo "Enable ssh password login on ssh"
sed '/^PasswordAuthentication/s/no/yes/' /etc/ssh/sshd_config -i
systemctl restart sshd

# Update all
echo "Update all"
dnf update -y  > /dev/null 2>&1

# insstall epel repo
dnf install epel-release -y > /dev/null 2>&1

# Install loosends
echo "Install loosends"
dnf install -y vim net-tools git sshpass tree glusterfs-client wget > /dev/null 2>&1

# Install Docker
echo "Install Docker"
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
dnf install -y docker-ce docker-ce-cli containerd.io --nogpgcheck > /dev/null 2>&1
systemctl enable docker  > /dev/null 2>&1
systemctl start docker
usermod -aG  docker vagrant

# Kubaadm prep
echo "Kubaadm prep"
sysctl -w net.bridge.bridge-nf-call-ip6tables=1 > /dev/null 2>&1
echo "net.bridge.bridge-nf-call-ip6tables = 1" >> /usr/lib/sysctl.d/50-default.conf
sysctl -w net.bridge.bridge-nf-call-iptables=1 > /dev/null 2>&1
echo "net.bridge.bridge-nf-call-iptables = 1" >> /usr/lib/sysctl.d/50-default.conf
sed -i '/^\/.*swap.*swap/s/^/#/' /etc/fstab
swapoff -a

# Turn off selinux
echo "Turn off selinux"
setenforce 0 > /dev/null 2>&1
sed 's/enforcing/disabled/' /etc/selinux/config -i

# Install kubeadm, kubectl, and kubelet
echo "Install kubeadm, kubectl, and kubelet"
cat > /etc/yum.repos.d/kubernetes.repo <<- "EOF"
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
yum install --disableexcludes=all kubelet kubeadm kubectl -y > /dev/null 2>&1
IP=`hostname -I | awk '{print $2}'`
sed "s/^KUBELET_EXTRA_ARGS=$/KUBELET_EXTRA_ARGS=--node-ip=$IP/" /etc/sysconfig/kubelet -i
systemctl enable kubelet  > /dev/null 2>&1
systemctl start kubelet
