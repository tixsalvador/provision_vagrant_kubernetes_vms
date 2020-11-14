# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.box_check_update = true
  config.vm.provider "virtualbox" do |vb|
    vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
  end

  config.vm.provision "shell", path: "provision.sh"

  config.vm.define "master-k8" do |master|
    master.vm.hostname = "masteri-k8"
    master.vm.network "private_network", ip: "10.10.10.10"
    master.vm.network "public_network", bridge: "Killer Wireless-n/a/ac 1535 Wireless Network Adapter"
    master.vm.provision "shell", path: "master.sh"
#    master.vm.provision "shell", inline: "yum install -y nfs-utils"
#    master.vm.provision "shell", inline: "systemctl enable nfs-server"
#    master.vm.provision "shell", inline: "systemctl start nfs-server"
#    master.vm.provision "shell", inline: "mkdir -p /mnt/nfs/{data,content}"
#    master.vm.provision "shell", inline: "mkdir -p /mnt/nfs/data/{mysql0,mysql1,mysql2,etcd0,etcd1,etcd2}"
#    master.vm.provision "shell", inline: "chmod -R 777 /mnt/nfs"
#    master.vm.provision "shell", inline: "echo '/mnt/nfs/data  10.10.10.0/24(rw,sync,no_subtree_check)' | tee -a /etc/exports"
#    master.vm.provision "shell", inline: "echo '/mnt/nfs/content  10.10.10.0/24(rw,sync,no_subtree_check,no_root_squash)' | tee -a /etc/exports"
#    master.vm.provision "shell", inline: "exportfs -a"
    master.vm.provider "virtualbox" do |v|
      v.name = "master_k8"
      v.memory = 2048
      v.cpus = 2
    end
  end

  $instance=2
  (1..$instance).each do |i|
         config.vm.define "node-k8#{i}" do |node|
           node.vm.hostname =  "node-k8#{i}"
           node.vm.network "private_network", ip: "10.10.10.#{i+10}"
           node.vm.provider "virtualbox" do |v|
            v.name = "node_k8#{i}"
            v.memory = 1024
            v.cpus = 1
           end
           node.vm.provision "shell", path: "worker.sh"
##           node.vm.provision "shell", inline: "mkdir /mnt/data"
##           node.vm.provision "shell", inline: "sed -i \'$ a 10.10.10.10:/mnt/nfs /mnt/data nfs   rw,sync,hard,intr 0 0\' /etc/fstab"
##           node.vm.provision "shell", inline: "mount -a"
         end
  end
end
