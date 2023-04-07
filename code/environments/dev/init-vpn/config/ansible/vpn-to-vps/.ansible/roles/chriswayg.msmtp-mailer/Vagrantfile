# -*- mode: ruby -*-
# vi: set ft=ruby ts=2 sw=2 tw=0 et :

boxes = [
  # {
  #   :name => "ubuntu-1204",
  #   :box => "bento/ubuntu-12.04",
  #   :ip => '10.0.0.11',
  #   :cpu => "50",
  #   :ram => "256"
  # },
  # {
  #   :name => "ubuntu-1404",
  #   :box => "bento/ubuntu-14.04",
  #   :ip => '10.0.0.12',
  #   :cpu => "50",
  #   :ram => "256"
  # },
  {
    :name => "ubuntu-1604",
    :box => "bento/ubuntu-16.04",
    :ip => '10.0.0.13',
    :cpu => "50",
    :ram => "256"
  },
  # {
  #   :name => "debian-7",
  #   :box => "bento/debian-7",
  #   :ip => '10.0.0.14',
  #   :cpu => "50",
  #   :ram => "256"
  # },
  # {
  #   :name => "debian-8",
  #   :box => "bento/debian-8",
  #   :ip => '10.0.0.15',
  #   :cpu => "50",
  #   :ram => "256"
  # },
  {
    :name => "debian-9",
    :box => "bento/debian-9",
    :ip => '10.0.0.16',
    :cpu => "50",
    :ram => "256"
  },
  {
    :name => "archlinux",
    :box => "archlinux/archlinux",
    :ip => '10.0.0.17',
    :cpu => "50",
    :ram => "256"
  },
  {
    :name => "alpine",
    :box => "chriswayg/alpine-3.7-x86_64",
    :ip => '10.0.0.18',
    :cpu => "50",
    :ram => "256"
  },
  {
    :name => "rancheros",
    :box => "chriswayg/RancherOS",
    :ip => '10.0.0.19',
    :cpu => "50",
    :ram => "256"
  },
]

role = File.basename(File.expand_path(File.dirname(__FILE__)))

Vagrant.configure("2") do |config|
  boxes.each do |box|
    # If archlinux gives an error with Linux 4.16 Virtualbox guest driver, disable synced folder
    config.vm.define box[:name] do |vms|
      vms.vm.box = box[:box]
      #vms.vm.hostname = "#{role}-#{box[:name]}"
      vms.vm.synced_folder ".", "/vagrant", disabled: true
      vms.vm.provider "virtualbox" do |v|
        v.check_guest_additions = false
        v.functional_vboxsf = false
        v.memory = "1024"
        # v.customize ["modifyvm", :id, "--cpuexecutioncap", box[:cpu]]
        # v.customize ["modifyvm", :id, "--memory", box[:ram]]
      end

      #vms.vm.network :private_network, ip: box[:ip]

      vms.vm.provision :ansible do |ansible|
        ansible.playbook = "tests/vagrant.yml"
        ansible.verbose = "vv"
        ansible.compatibility_mode = "2.0"
      end
    end
  end
end
