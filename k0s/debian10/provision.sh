#!/bin/sh

# To suppress the stdin warning message
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

# reset root and vagrant password to default
usermod --password $(echo vagrant | openssl passwd -1 -stdin) vagrant

# Fix pre-flight errors
modprobe br_netfilter
echo br_netfilter >> /etc/modules
echo 1 > /proc/sys/net/ipv4/ip_forward
sed '/net.ipv4.ip_forward/s/^#//' -i /etc/sysctl.conf
sysctl --system

# Prepare ssh keys for k0s
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# THIS IS TO TEST REVERT
