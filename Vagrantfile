# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.7.0"

Vagrant.configure("2") do |config|
  config.vm.provider "hyperv"
  config.vm.box = "kmm/ubuntu-xenial64"

  master = 1
  node = 2
  private_count = 10
  (1..(master + node)).each do |mid|
    name = (mid <= node) ? "node" : "master"
    id   = (mid <= node) ? mid : (mid - node)
    config.vm.define "#{name}#{id}" do |n|
      n.vm.hostname = "#{name}#{id}"
      n.vm.synced_folder ".", "/vagrant", smb_host: "<you_host_ip>", smb_username: "<username>", smb_password: "<password>"
      # Hyper-V provider has some limitation that it can't assign static by now!
      # The following n.vm.network settings will totally ignored by Vagrant with Hyper-V provider.
      ip_addr = "192.168.137.#{private_count}"
      n.vm.network "private_network", ip: "#{ip_addr}"
      n.vm.provider "hyperv" do |v|
        v.vmname = "#{name}#{id}"
        v.memory = 2048
        v.cpus = 2
      end
      private_count += 1
    end
  end
  config.vm.provision :shell, path: "./hacks/deps.sh"
end
