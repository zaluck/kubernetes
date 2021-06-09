# -*- mode: ruby -*-
# vi: set ft=ruby :
hosts = {
  "n1" => "192.168.77.10",
  "n2" => "192.168.77.11",
  "n3" => "192.168.77.12",
  "n4" => "192.168.77.13"
}
Vagrant.configure("2") do |config|
  # всегда используем небезопасный ключ Vagrant
  config.ssh.insert_key = false
  # перенаправляем ssh-агент, чтобы получить легкий доступ к разным узлам
  config.ssh.forward_agent = true
  check_guest_additions = false
  functional_vboxsf = false

#   config.vm.box = "bento/ubuntu-16.04"
#   config.vm.box = "ubuntu/trusty64"
config.vm.box = "generic/ubuntu1604"
# config.vm.synced_folder "d:/_WORK/_DevOps/_Kubernetes/", "/mnt"
config.vm.synced_folder "d:/_WORK/_DevOps/_Kubernetes/", "/mnt", type: "rsync"
  
hosts.each do |name, ip|
    config.vm.hostname = name
    config.vm.define name do |machine|
      machine.vm.network :private_network, ip: ip
      machine.vm.provider "virtualbox" do |v|
        v.name = name
		#   v.memory = 512
		  v.memory = 2048
		  v.cpus = 2
      end
    end
  end
end
