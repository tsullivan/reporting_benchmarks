# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Start Kibana and go to localhost:5777 in your host's browser
  config.vm.network :forwarded_port, guest: 5601, host: 5777

  config.vm.provider "virtualbox" do |vbox|
    vbox.customize ["modifyvm", :id, "--audio", "none"]
    vbox.memory = 8000
    vbox.cpus = 4
    vbox.gui = false
  end

  # Ubuntu machine
  config.vm.define "kibana-reporting-ubuntu" do |ubuntu|
    ubuntu.vm.box = "ubuntu/focal64"
    ubuntu.vm.box_version = "20220215.1.0"
    ubuntu.vm.hostname = "reporting-benchmark"

    ubuntu.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y jq
    SHELL

    ubuntu.vm.provision "shell", inline: "sh /vagrant/setup/bootstrap.sh", env: {"VERSION" => ENV['VERSION']}

    ubuntu.vm.provision "shell", inline: <<-SHELL
      apt-get install -y libnss3 fonts-liberation libfontconfig1
    SHELL

    # enable auto-sizing swap service
    # ubuntu.vm.provision "shell", inline: "sudo apt-get install swapspace -y"
  end
end
