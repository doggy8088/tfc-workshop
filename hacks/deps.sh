#!/bin/bash
#
# Program: Initial vagrant.
# History: 2017/12/23 Kyle.b Release
# History: 2017/12/25 Will
# - Fixed Hyper-V problem


function set_hosts() {
cat <<EOF > ~/hosts
127.0.0.1   localhost
::1         localhost

192.168.137.10 node1
192.168.137.11 node2
192.168.137.12 master1

EOF
}

set -e
HOST_NAME=$(hostname)
OS_NAME=$(awk -F= '/^NAME/{print $2}' /etc/os-release | grep -o "\w*"| head -n 1)

# Due to Vagrant's Limited Networking on Hyper-V, IP address have to change manually after VM deployed.
# https://www.vagrantup.com/docs/hyperv/limitations.html
#sudo sed -ie 's/iface eth0 inet dhcp//g' /etc/network/interfaces
#sudo sh -c 'echo "iface eth0 inet static" >> /etc/network/interfaces'
#sudo sh -c 'echo "netmask 255.255.255.0" >> /etc/network/interfaces'
#sudo sh -c 'echo "gateway 192.168.137.1" >> /etc/network/interfaces'
#if [ ${HOST_NAME} == "node1" ]; then
#  sudo sh -c 'echo "address 192.168.137.10" >> /etc/network/interfaces'
#fi  
#if [ ${HOST_NAME} == "node1" ]; then
#  sudo sh -c 'echo "address 192.168.137.11" >> /etc/network/interfaces'
#fi  
#if [ ${HOST_NAME} == "master1" ]; then
#  sudo sh -c 'echo "address 192.168.137.12" >> /etc/network/interfaces'
#fi  



if [ ${HOST_NAME} == "master1" ]; then
  sudo sed -i 's/at.archive.ubuntu.com/tw.archive.ubuntu.com/g' /etc/apt/sources.list
  sudo apt-add-repository -y ppa:ansible/ansible
  sudo apt-get update && sudo apt-get install -y ansible git sshpass python-netaddr libssl-dev
  
  yes "/root/.ssh/id_rsa" | sudo ssh-keygen -t rsa -N ""
  #HOSTS="192.168.137.10 192.168.137.11 192.168.137.12"
  #for host in ${HOSTS}; do
  #  sudo sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@${host} "sudo mkdir -p /root/.ssh"
  #  sudo cat /root/.ssh/id_rsa.pub | sudo sshpass -p "vagrant" ssh -o StrictHostKeyChecking=no vagrant@${host} "sudo tee -a /root/.ssh/authorized_keys"
  #done
  #cd /vagrant
  set_hosts
  sudo cp ~/hosts /etc/
else
  set_hosts
  sudo cp ~/hosts /etc/
fi

# TODO: When networking restart, the `vagrant up` process will stop!
# sudo /etc/init.d/networking restart

